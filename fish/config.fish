# === Shell ===

# No greeting when starting an interactive shell.
function fish_greeting
end

# tmux
# if type -q tmux
#     if test "$TERM" != "screen" -a "$TERM" != "tmux" -a -z "$TMUX"
#         status is-interactive; and tmux
#     end
# end

# === fzf ===
set FZF_CTRL_T_COMMAND "ag -l"


# === Utility functions ===
function gst --description 'git status'
    git status
end

function jq-repl --description 'Interactive repl for jq'
    echo '' | fzf --print-query --preview "cat $argv[1] | jq -C -r {q}" --preview-window up:99%
end

# === Workspaces ===
set -gx DEV_PATH "$HOME/dev"
set -gx WS_DIR "$HOME/dev/code"
fish_add_path "$DEV_PATH/bin"

function repos --description 'Lists repos in the workspace directory'
    ls $WS_DIR
end

function ws --description 'Change directory to a repo'
   cd "$WS_DIR/$argv[1]"
end
complete -f -c ws -n "not __fish_seen_subcommand_from (repos)" -a "(repos)"

function current_repo --description 'Returns the current repo'
    if string match -rq "$WS_DIR.+" -- (pwd)
        echo (string match -r "$WS_DIR/(.*?)/" -- (pwd)/)[2]
    else
        echo ""
    end
end

# === Devtools and SDKs ===
fish_add_path "$DEV_PATH/maven@3.5/bin"
set JAVA_HOME "$DEV_PATH/Java/JavaVirtualMachines/amazon-corretto-17.jdk/Contents/Home/"
set NVM_DIR "$DEV_PATH/.nvm"
# load_nvm # NVM super slow on startup

# == Vim ==
set -gx MYVIMRC "$DEV_PATH/.vimrc"
set -gx VIMINIT ":set runtimepath+=$DEV_PATH/.vim|:source $MYVIMRC"


# === Miro ===

# THEME PURE #
set fish_function_path /Users/rick/.config/fish/functions/theme-pure/functions/ $fish_function_path
source /Users/rick/.config/fish/functions/theme-pure/conf.d/pure.fish

# AWS VAULT
set AWS_VAULT_KEYCHAIN_NAME login
set AWS_SESSION_TOKEN_TTL 12h

