#!/bin/bash

DOTFILES_DIR=$(realpath .)

# Base files
DOTFILES=(".zshrc" ".aliases" ".profile" ".gitconfig" ".gitignore")

for dotfile in ${DOTFILES[*]}; do
  ln -s "${DOTFILES_DIR}/${dotfile}" ~ && \
    echo "Linked ${dotfile}"
done

# Config Directories
CONFIG_DIR="$HOME/.config"
mkdir -p "${CONFIG_DIR}"

ln -s "${DOTFILES_DIR}/.config/i3" "${CONFIG_DIR}" && echo "Linked ./config/i3"