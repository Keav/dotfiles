#!/bin/bash

echo "Setting up dotfiles..."

# Generate SSH key if it doesn't exist
if [ ! -f ~/.ssh/github ]; then
    echo "Generating new SSH key..."
    ssh-keygen -t ed25519 -f ~/.ssh/github -C "$(whoami)@$(hostname)"
    
    # Start SSH agent and add key
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/github
    
    # Display public key for GitHub setup
    echo "\nAdd this public key to GitHub (https://github.com/settings/keys):"
    cat ~/.ssh/github.pub
    echo "\nPress Enter after adding the key to GitHub..."
    read
fi

# Set Git configuration
echo "Setting up Git configuration..."
read -p "Enter your Git username: " gituser
read -p "Enter your Git email: " gitemail
git config --global user.name "$gituser"
git config --global user.email "$gitemail"

# Clone dotfiles repository
echo "Cloning dotfiles repository..."
git clone git@github.com:Keav/dotfiles.git ~/dotfiles || {
    echo "Failed to clone repository. Please check your SSH key is added to GitHub"
    exit 1
}

# Create symlinks
echo "Creating symlinks..."
ln -s ~/dotfiles/.zshrc ~/.zshrc

# Set correct permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/github
chmod 644 ~/.ssh/github.pub

# Reload shell
echo "Setup complete! Reloading shell..."
source ~/.zshrc