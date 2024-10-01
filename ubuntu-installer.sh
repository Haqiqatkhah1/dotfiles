#!/bin/bash

check_error() {
  if [ $? -ne 0 ]; then
    echo "Error occurred. Exiting..."
    exit 1
  fi
}

echo "Adding your public key from GitHub..."
GITHUB_USERNAME="haqiqatkhah1"
mkdir -p ~/.ssh
curl -L "https://github.com/$GITHUB_USERNAME.keys" >> ~/.ssh/authorized_keys
check_error
chmod 600 ~/.ssh/authorized_keys
echo "Public key added."

echo "Installing Zsh..."
sudo apt update
sudo apt install zsh -y
check_error

echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
check_error

echo "Downloading .zshrc template..."
ZSHRC_REPO="https://raw.githubusercontent.com/Haqiqatkhah1/dotfiles/refs/heads/master/.zshrc"
curl -L "$ZSHRC_REPO" -o ~/.zshrc
check_error

echo "Setting Zsh as the default shell..."
chsh -s $(which zsh)
check_error

echo "Setup complete! Please log out and log back in for the changes to take effect."
