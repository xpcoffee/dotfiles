#--- GENERAL ---
HIST_STAMPS="yyyy-mm-dd"
ZSH_DISABLE_COMPFIX="true"

#--- OH-MY-ZSH ---
export ZSH="/home/rick/.oh-my-zsh"
ZSH_THEME="xpcoffee"
CASE_SENSITIVE="false" # for completion
DISABLE_UNTRACKED_FILES_DIRTY="true" # don't show git status changes for untracked files

plugins=(
  git # status in prompts
  thefuck # correct erroneous commands
  fzf # fuzzy-find menus
)

source $ZSH/oh-my-zsh.sh

#--- USER CONFIGURATION ---
source ~/.profile
source ~/.aliases

#--- Base16 Shell ---
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

