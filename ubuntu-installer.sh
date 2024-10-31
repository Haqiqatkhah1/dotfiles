#!/bin/bash

# === Configuration Section ===
# Specify the URL for your .zshrc file
ZSHRC_URL="https://raw.githubusercontent.com/Haqiqatkhah1/dotfiles/refs/heads/master/.zshrc"  # Replace with your actual .zshrc file URL

# Specify your GitHub username for fetching the public key
GITHUB_USERNAME="haqiqatkhah1"  # Replace with your GitHub username

# === End of Configuration Section ===

# Step 1: Install zsh if it’s not installed
if ! command -v zsh &> /dev/null; then
  echo "Installing zsh..."
  sudo apt update && sudo apt install -y zsh git || { echo "Failed to install zsh"; exit 1; }
else
  echo "zsh is already installed."
fi

# Step 2: Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || { echo "Failed to install Oh My Zsh"; exit 1; }
else
  echo "Oh My Zsh is already installed."
fi

# Step 3: Download and replace the .zshrc configuration
echo "Fetching .zshrc configuration from $ZSHRC_URL..."
curl -o "$HOME/.zshrc" "$ZSHRC_URL" || { echo "Failed to download .zshrc file"; exit 1; }

if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
  echo "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" || { echo "Failed to install zsh-autosuggestions"; exit 1; }
else
  echo "zsh-autosuggestions is already installed."
fi

# Step 4: Install zsh-syntax-highlighting
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
  echo "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" || { echo "Failed to install zsh-syntax-highlighting"; exit 1; }
else
  echo "zsh-syntax-highlighting is already installed."
fi

# Step 4: Fetch the GitHub public key and add it to authorized_keys
echo "Fetching GitHub public key for $GITHUB_USERNAME..."
GITHUB_KEY_URL="https://github.com/$GITHUB_USERNAME.keys"
curl -s "$GITHUB_KEY_URL" >> "$HOME/.ssh/authorized_keys" || { echo "Failed to fetch GitHub public key"; exit 1; }
chmod 600 "$HOME/.ssh/authorized_keys"
echo "Public key added to authorized_keys."

# Step 5: Configure SSH to allow only public key authentication
echo "Configuring SSH settings for key-based authentication..."
SSH_CONFIG_FILE="/etc/ssh/sshd_config"
sudo sed -i 's/#\?PasswordAuthentication yes/PasswordAuthentication no/' "$SSH_CONFIG_FILE"
sudo sed -i 's/#\?PubkeyAuthentication no/PubkeyAuthentication yes/' "$SSH_CONFIG_FILE"
echo "SSH settings updated. Restarting SSH service..."
sudo systemctl restart ssh || sudo service ssh restart

echo "Setup complete. Please log out and log back in to start using zsh as the default shell."
