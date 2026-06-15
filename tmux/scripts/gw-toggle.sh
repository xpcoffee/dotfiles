#!/usr/bin/env bash
# Switches to the previously-focused window across all sessions (global
# last-window toggle). Pairs with gw-record.sh, which maintains @gw_prev.
set -euo pipefail

target=$(tmux show-option -gqv @gw_prev)
[ -z "$target" ] && exit 0

# Window may have been closed since it was recorded.
tmux list-windows -a -F '#{window_id}' | grep -qx "$target" || exit 0

sess=$(tmux display-message -p -t "$target" '#{session_name}')
tmux switch-client -t "$sess"
tmux select-window -t "$target"
