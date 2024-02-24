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

declare -A osInfo;
osInfo[/etc/debian_version]="apt-get update && apt-get install -y stow"
osInfo[/etc/alpine-release]="apk update && apk --update add stow"
osInfo[/etc/centos-release]="yum update && yum install -y stow"
osInfo[/etc/fedora-release]="dnf check-update && dnf install -y stow"

for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        package_manager_install=${osInfo[$f]}
    fi
done

if ! command -v stow &> /dev/null
then
    echo "GNU stow not found. Installing it using ${package_manager_install}."
    ${package_manager_install}
fi

#################
#     $HOME     #
#################

HOME_DIRECTORY_CONFIG=("vim" "tmux" "zsh" "emacs" "git")

for config in ${HOME_DIRECTORY_CONFIG[*]}; do
   stow --adopt --target="${HOME}" "${config}"
done

################
#   .config    #
################

CONFIG_DIRECTORY_CONFIG=("fish")

HOME_CONFIG_DIR="${HOME}/.config"
mkdir -p "${HOME_CONFIG_DIR}"

for config in ${CONFIG_DIRECTORY_CONFIG[*]}; do
    stow --adopt --target=${HOME_CONFIG_DIR} "${config}" 
done

echo "Dotfiles installed."
echo "Differences:"
git status -s