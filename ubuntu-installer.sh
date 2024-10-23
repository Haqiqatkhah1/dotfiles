#!/bin/bash

# Check for root privileges
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Variables
GITHUB_USERNAME="haqiqatkhah1" # Change this to your GitHub username
ZSHRC_URL="https://raw.githubusercontent.com/Haqiqatkhah1/dotfiles/refs/heads/master/.zshrc" # Replace with the URL to the .zshrc file you want to download

# Step 1: Update and install necessary packages
echo "Updating package lists and installing git, zsh, nano..."
apt update && apt upgrade -y
apt install -y git zsh nano curl wget

# Step 2: Install Oh My Zsh
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Step 3: Change default shell to Zsh
echo "Changing default shell to zsh..."
chsh -s $(which zsh)

# Step 4: Fetch public SSH key from GitHub
echo "Fetching public SSH key from GitHub..."
curl -s https://github.com/$GITHUB_USERNAME.keys >> ~/.ssh/authorized_keys

# Step 5: Set proper permissions for .ssh and authorized_keys
echo "Setting proper permissions for .ssh and authorized_keys..."
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

# Step 6: Download .zshrc and replace the current one
echo "Downloading .zshrc from $ZSHRC_URL..."
wget -O ~/.zshrc $ZSHRC_URL

# Step 7: Apply new .zshrc
echo "Applying new .zshrc..."
source ~/.zshrc

echo "Setup complete. Please log out and log back in for the changes to take effect."

