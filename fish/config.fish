function gst --description 'git status'
    git status
end

function jq-repl --description 'Interactive repl for jq'
    echo '' | fzf --print-query --preview "cat $argv[1] | jq -C -r {q}" --preview-window up:99%
end

set WS_DIR "$HOME/code"

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

function fish_title --description 'Change the tab title to a random emoji'
    if set -q argv[1]
        echo (random-emoji) $argv;
    else
        echo (random-emoji) (basename $PWD);
    end
end
