if status is-interactive
    zoxide init fish --cmd cd | source
end

string match -q "$TERM_PROGRAM" "vscode"
and . (code --locate-shell-integration-path fish)

