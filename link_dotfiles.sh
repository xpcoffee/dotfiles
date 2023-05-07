#!/bin/bash

# Creates symlinks for all my stuff; the symlinks mean that I can modify files and stil
# have changes register under version control.

# Why a bash script? This will work on new hosts that don't yet have fancy things installed.

set -euo pipefail

# Get absolute path to dotfiles directory
CURRENT_PATH=`realpath $0`
DOTFILES_DIR=`dirname ${CURRENT_PATH}`

################
#     Files    #
################

DOTFILES=(".aliases" ".profile" ".zshrc" ".vimrc" ".vim" ".gitconfig" ".tmux.conf" ".ssh/config" ".ctags")

for dotfile in ${DOTFILES[*]}; do
    FROM_PATH="${DOTFILES_DIR}/${dotfile}"
    TO_PATH="${HOME}/${dotfile}"

    if [ -s "${TO_PATH}" ]; then
        echo -e "Skipping linking \033[1m${dotfile}\033[0m: already linked."
    elif [ -L "${TO_PATH}" ]; then
        echo -e "Skipping linking \033[1m${dotfile}\033[0m: already linked."
    elif [ -f "${TO_PATH}" ]; then
        echo -e "Skipping linking \033[1m${dotfile}\033[0m: a file already exists."
    else
        ln -s "${FROM_PATH}" "${TO_PATH}" && echo -e "Created symlink for \033[1m${dotfile}\033[0m"
    fi
done

################
#   .config    #
################

HOME_CONFIG_DIR="${HOME}/.config"
mkdir -p "${HOME_CONFIG_DIR}"

CONFIG_DIRS=("fish")
for config_dir in ${CONFIG_DIRS[*]}; do
    DIR_TO_LINK=".config"
    FROM_DIR="${DOTFILES_DIR}/${DIR_TO_LINK}/${config_dir}/"
    TO_DIR="${HOME}/${DIR_TO_LINK}/${config_dir}"

    if [ -s "${TO_DIR}" ]; then
        echo -e "Skipping linking \033[1m${config_dir}\033[0m: already linked."
    elif [ -L "${TO_DIR}" ]; then
        echo -e "Skipping linking \033[1m${config_dir}\033[0m: already linked."
    elif [ -d "${TO_DIR}" ]; then
        echo -e "Skipping linking \033[1m${config_dir}\033[0m: a directory already exists there."
    else
        ln -s "${FROM_DIR}" "${TO_DIR}" && echo -e "Created symlink for \033[1m${config_dir}\033[0m"
    fi
done

################
#  Appearance  #
################

if [ -z ${ZSH+x} ]
then
    echo -e "Skipping setting up \033[1mZsh config\033[0m: ZSH environment variable not set."
else
    mkdir -p "${ZSH}/themes"
    ln -s "${DOTFILES_DIR}/.oh-my-zsh/themes/rickbo.zsh-theme" "${ZSH}/themes" && echo -e "Created symlink for \033[1m.oh-my-zsh/themes/rickbo.zsh-theme\033[0m"
fi
