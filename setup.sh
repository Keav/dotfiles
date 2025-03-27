#!/bin/bash

# Clone dotfiles repository
git clone <your-github-repo-url> ~/dotfiles

# Create symlinks
ln -s ~/dotfiles/.zshrc ~/.zshrc

# Reload shell
source ~/.zshrc