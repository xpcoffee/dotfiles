#!/bin/bash

# install.sh
#
# Uses GNU stow to create symbolic links between configuration in this repository and the locations they expect to be found by software.
# Enables config to be managed, version-controlled and installed altogether.
# Bash was chosen to allow this to run on a minimal posix system.

set -euo pipefail

####################################
#   Ensure GNU stow is installed   #
####################################

if ! command -v stow &>/dev/null; then
    echo "GNU stow not found. Trying to install it..."
    
    if [[ -f "/etc/debian_version" ]]; then
        apt-get update && apt-get install -y stow
    elif [[ -f "/etc/alpine-release" ]]; then
        apk update && apk --update add stow
    elif [[ -f "/etc/centos-release" ]]; then
        yum update && yum install -y stow
    elif [[ -f "/etc/fedora-release" ]]; then
        dnf check-update && dnf install -y stow
    else
        echo "No installation instruction found."
        exit 1
    fi
fi

#################
#     $HOME     #
#################

HOME_DIRECTORY_CONFIG=("tmux" "zsh" "git" "bash")

for config in ${HOME_DIRECTORY_CONFIG[*]}; do
    stow --adopt --target="${HOME}" "${config}"
done

################
#   .config    #
################

CONFIG_DIRECTORY_CONFIG=("fish" "nvim" "powerline-shell")

for config in ${CONFIG_DIRECTORY_CONFIG[*]}; do
    HOME_CONFIG_DIR="${HOME}/.config/${config}"
    mkdir -p "${HOME_CONFIG_DIR}"
    stow --adopt --target="${HOME_CONFIG_DIR}" "${config}"
done

echo "Dotfiles installed."
echo "Differences:"
git status -s
