# Non-Shell specific config - used mostly to set up variables needed no matter which shell you're in

# --- non-shell specific options ---
export EDITOR='vim'
export GEM_PATH="${HOME}/.gem"

# --- path ---
PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin" # system bins
PATH="/snap/bin:${PATH}" # snaps
PATH="/opt/firefox-dev/:${PATH}"
PATH="${HOME}/bin:${PATH}" # user bin
PATH="${HOME}/.toolbox/bin:${PATH}" # Builder tools
PATH="${GEM_PATH}/bin:${PATH}" # Gem path
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
