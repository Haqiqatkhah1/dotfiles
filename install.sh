#!/bin/bash

# Function to install zsh
install_zsh() {
    echo "Installing zsh..."
    sudo apt update
    sudo apt install -y zsh
    chsh -s $(which zsh)
}

# Function to install Oh My Zsh
install_oh_my_zsh() {
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

# Function to insert public key from GitHub into server
insert_public_key() {
    echo "Inserting public key from GitHub into the server..."
    mkdir -p ~/.ssh
    curl https://github.com/haqiqatkhah1.keys >> ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
}

# Function to insert .zshrc configuration
insert_zshrc_configuration() {
    echo "Fetching and inserting .zshrc configuration..."
    curl -fsSL https://raw.githubusercontent.com/Haqiqatkhah1/dotfiles/master/.zshrc -o ~/.zshrc
    source ~/.zshrc
}

# Function to install zsh-autosuggestions
install_zsh_autosuggestions() {
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}

# Function to install zsh-syntax-highlighting
install_zsh_syntax_highlighting() {
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
}

# Function to ask and install Docker and Docker Compose
install_docker() {
    read -p "Do you want to install Docker and Docker Compose? (y/n): " INSTALL_DOCKER
    if [ "$INSTALL_DOCKER" == "y" ]; then
        echo "Installing Docker..."
        sudo apt update
        sudo apt install -y \
            ca-certificates \
            curl \
            gnupg \
            lsb-release
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
          $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt update
        sudo apt install -y docker-ce docker-ce-cli containerd.io

        echo "Installing Docker Compose..."
        sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
    fi
}

# Function to ask and install NGINX
install_nginx() {
    read -p "Do you want to install NGINX? (y/n): " INSTALL_NGINX
    if [ "$INSTALL_NGINX" == "y" ]; then
        echo "Installing NGINX..."
        sudo apt update
        sudo apt install -y nginx
    fi
}

# Main script execution
install_zsh
install_oh_my_zsh
insert_public_key
insert_zshrc_configuration
install_zsh_autosuggestions
install_zsh_syntax_highlighting
install_docker
install_nginx

echo "Setup completed successfully!"
