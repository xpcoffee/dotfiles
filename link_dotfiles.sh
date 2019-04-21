#!/bin/bash

DOTFILES_DIR=$(realpath .)

# Core

DOTFILES=(".zshrc" ".aliases" ".profile" ".gitconfig" ".gitignore")

for dotfile in ${DOTFILES[*]}; do
  ln -s "${DOTFILES_DIR}/${dotfile}" "${HOME}" && \
    echo "Linked ${dotfile}"
done

# .config

CONFIG_DIR="${HOME}/.config"
mkdir -p "${CONFIG_DIR}"

ln -s "${DOTFILES_DIR}/.config/i3" "${CONFIG_DIR}" && echo "Linked ./config/i3"

# Appearance

ln -s "${DOTFILES_DIR}/.oh-my-zsh/themes/xpcoffee.zsh-theme" "${ZSH}/themes" && echo "Linked oh-my-zsh theme"