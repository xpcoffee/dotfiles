# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ----------------
# Shell
# ----------------

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=10000
export HISTFILESIZE=10000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias oldvim="vim"
alias vim='vim_with_dir'
[ -s "$HOME/bin/nvim.appimage" ] && alias nvim="$HOME/bin/nvim.appimage" 
alias gst="git status"
alias ssh-id-xpc='eval "$(ssh-agent)" && ssh-add ~/.ssh/xpc_id_ed25519'
alias cat='batcat'
alias rider='/opt/JetBrains\ Rider-2024.3.3/bin/rider'

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH /snap/bin
if [ -d "/snap/bin" ] ; then
    PATH="/snap/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi


# binaries & env
[ -f $HOME/.local/bin ] && export PATH=$PATH:$HOME/.local/bin
[ -f $HOME/.local/bin/env ] && . "$HOME/.local/bin/env"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Powerline shell
function _update_ps1() {
    PS1=$(powerline-shell $?)
}

if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

eval "$(zoxide init bash)"

if command -v z &> /dev/null
then
    alias oldcd=cd
    alias cd=z
fi


# ----------------
# Go
# ----------------
if [ -d "/opt/go/bin" ] ; then
    PATH="/opt/go/bin:$PATH"
fi

if [ -x "$(command -v go)" ]; then
    PATH="$PATH:$(go env GOPATH)/bin"
fi

# ----------------
# Node & Javascript
# ----------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ----------------
# C#
# ----------------

# dotnet
if [ -d "$HOME/.dotnet" ] ; then
  export DOTNET_ROOT=$HOME/.dotnet
  export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools

  export NUGET_CREDENTIALPROVIDER_MSAL_ENABLED=true
  export NUGET_CREDENTIALPROVIDER_FORCE_CANSHOWDIALOG_TO=true
fi

# ----------------
# Vim
# ----------------
export PATH="$PATH:/opt/nvim-linux-x86_64/bin/"
function vim_with_dir() {
  if [ $# -eq 0 ]; then
     nvim -c "Oil"
   else
     nvim "$@";
  fi
}

# ----------------
# Ranger
# ----------------
if command -v ranger &> /dev/null
then
    alias r=ranger
fi

# Generic watch function
function watch() {
    while true
    do
        inotifywait -q -r -e create,close_write,modify,move,delete ./ && "$@"
    done
}

# ----------------
# Java
# ----------------
if [ -d "/usr/lib/jvm/jdk-21.0.4+7/" ] ; then
  export JAVA_HOME="/usr/lib/jvm/jdk-21.0.4+7/"
fi

# ----------------
# Git
# ----------------
# git feature branch
function gfb() {
  git checkout -b "emerick/${1}" "origin/master"
}

# worktree helper - wraps bin/wt so add/cd can change directory
function wt() {
  case "$1" in
    add|cd)
      local dir
      dir=$(command wt "$@") && [[ -n "$dir" ]] && builtin cd "$dir"
      ;;
    *)
      command wt "$@"
      ;;
  esac
}

alias lg=lazygit
alias gl="git lag"

# ----------------
# Fzf
# ----------------
if command -v fzf &> /dev/null
then
  # Set up fzf key bindings and fuzzy completion
  eval "$(fzf --bash)"
fi
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# ----------------
# K9s
# ----------------
if [ -f "/snap/k9s/current/bin/k9s" ] ; then
  alias k9s=/snap/k9s/current/bin/k9s
fi

# ----------------
# agent-browser
# ----------------
AGENT_BROWSER_EXECUTABLE_PATH=/mnt/c/Users/emerick/AppData/Local/Temp/admin-chrome-profile/
AGENT_BROWSER_STREAM_PORT=9223

# ----------------
# Work
# ----------------
[ -f ~/.bashrc_work ] && source ~/.bashrc_work
[ -f ~/.config/bash/work-functions.sh ] && source ~/.config/bash/work-functions.sh
