ulimit -S -n 100000

# ---- Terminal ----
export LANG=en_US.UTF-8
setopt NO_BEEP

# ---- Base16 colourschemes ----
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

# ---- NVM ---
export NVM_HOMEBREW=$(brew --prefix nvm)
export NVM_DIR=$(brew --prefix nvm)

# ---- Oh-my-Zsh ----
plugins=(
    git
    fzf
    zsh-autosuggestions
    nvm
)

export ZSH="${HOME}/.oh-my-zsh"
source "${ZSH}/oh-my-zsh.sh"

# ---- Environment ----
# source ~/.profile
source ~/.aliases

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
