#!/bin/bash

# Step 1: Download the GPG backup file
echo "Please enter the URL for the GPG backup file:"
read -r gpg_backup_url
wget "$gpg_backup_url" -O gpg_backup.key

# Step 2: Restore the GPG file
echo "Please enter your passphrase for the GPG file:"
read -rs gpg_passphrase
gpg --import --batch --yes --passphrase "$gpg_passphrase" gpg_backup.key

# Installing zsh and Oh My Zsh, then setting zsh as the default shell
sudo apt-get install -y zsh git
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
chsh -s $(which zsh)

# Step 3: Clone the Git repository
echo "trying to get repo"
git_repo_url="https://github.com/Haqiqatkhah1/dotfiles.git"
git clone "$git_repo_url"
cd dotfiles/

# Step 4: Decrypt a GPG file in the repository, extract it to the root directory
echo "Trying to decrypt File"
for file in *.gz.gpg; do
    # Remove the '.gpg' extension to get the output file name for the decrypted tar.gz file
    output="${file%.gpg}"

    # Decrypt the file
    gpg --output "$output" --decrypt "$file"

    # Extract the tar.gz file, assuming extraction to the root directory is required
    sudo tar xzf "$output" -C /

    # Optional: Remove the decrypted tar.gz file if you no longer need it
    rm "$output"
done
cd ~
rm -rf dotfiles/
# Notifying the user of script completion
echo "Script execution completed."
