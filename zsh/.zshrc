# ---- Terminal ----
export LANG=en_US.UTF-8
setopt NO_BEEP

# ---- Base16 colourschemes ----
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

# ---- Oh-my-Zsh ----
plugins=(
    git
    fzf
    zsh-autosuggestions
)

export ZSH="${HOME}/.oh-my-zsh"
source "${ZSH}/oh-my-zsh.sh"


# ---- Environment ----
source ~/.profile
source ~/.aliases

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh



