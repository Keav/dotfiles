#!/bin/bash

# Clone dotfiles repository
git clone git@github.com:Keav/dotfiles.git ~/dotfiles

# Create symlinks
ln -s ~/dotfiles/.zshrc ~/.zshrc

# Reload shell
source ~/.zshrc