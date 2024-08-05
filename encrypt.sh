#!/bin/bash

RECIPIENT="80378148214C563D"
BACKUP_DIR="$HOME/backup"
COMBINED_ARCHIVE="DOT_FILES"
DECRYPTED_ARCHIVE="decrypted_DOT_FILES.tar.gz"
REMOTE_REPO="https://github.com/Haqiqatkhah1/dotfiles.git"

# Paths to items to encrypt
ITEMS_TO_ENCRYPT=(
  "$HOME/.ssh/"
  "$HOME/.kube/config"
  "$HOME/wire.conf"
  "$HOME/.zshrc"
  "$HOME/backupkeys.pgp"
  "$HOME/encrypt.sh"
  "$HOME/recoverycodes"
  "$HOME/.config/terminator"
  "$HOME/.config/github_copilot"
  "$HOME/.config/JetBrains"
)

# Encrypt function
encrypt() {
  if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
  fi

  tar czvf "$COMBINED_ARCHIVE.tar.gz" "${ITEMS_TO_ENCRYPT[@]}"
  gpg --output "$COMBINED_ARCHIVE.tar.gz.gpg" --encrypt --recipient $RECIPIENT "$COMBINED_ARCHIVE.tar.gz"

  if [ $? -eq 0 ]; then
    mv "$COMBINED_ARCHIVE.tar.gz.gpg" "$BACKUP_DIR/"
    echo "Backup stored: $BACKUP_DIR/$COMBINED_ARCHIVE.tar.gz.gpg"
    rm "$COMBINED_ARCHIVE.tar.gz"
    cp "$HOME/.zshrc" $BACKUP_DIR/
    cp "$HOME/encrypt.sh" "$BACKUP_DIR/"
    git_push
  else
    echo "Failed to encrypt $COMBINED_ARCHIVE.tar.gz"
  fi
}

# Decrypt function
decrypt() {
  git_pull
  if [ -f "$BACKUP_DIR/$COMBINED_ARCHIVE.tar.gz.gpg" ]; then
    gpg --output "$DECRYPTED_ARCHIVE" --decrypt "$BACKUP_DIR/$COMBINED_ARCHIVE.tar.gz.gpg"
    if [ $? -eq 0 ]; then
      tar xzvf "$DECRYPTED_ARCHIVE" -C "$HOME" --overwrite
      rm "$DECRYPTED_ARCHIVE"
      cp .zshrc $HOME
      echo "Succesfully Decrypted"
    else
      echo "Failed to decrypt $BACKUP_DIR/$COMBINED_ARCHIVE.tar.gz.gpg"
    fi
  else
    echo "Backup file not found: $BACKUP_DIR/$COMBINED_ARCHIVE.tar.gz.gpg"
  fi
}

# Git push function
git_push() {
  cd "$BACKUP_DIR" || exit
  git add .
  git commit -m "Backup on $(date)"
  git push origin master
}

# Git pull function
git_pull() {
  cd "$BACKUP_DIR" || exit
  git pull origin master
}

# Main script
case "$1" in
  encrypt)
    encrypt
    ;;
  decrypt)
    decrypt
    ;;
  *)
    echo "Usage: $0 {encrypt|decrypt}"
    exit 1
    ;;
esac
