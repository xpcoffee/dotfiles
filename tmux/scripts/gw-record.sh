#!/usr/bin/env bash
# Records the globally-active window into @gw_curr, shifting the previous one
# into @gw_prev. Invoked from tmux hooks with the focused window id ($1),
# expanded by tmux in the hook's context. Dedupes on window id so pane
# switches within a window don't pollute the history.
set -euo pipefail

cur="${1:-}"
[ -z "$cur" ] && exit 0

stored=$(tmux show-option -gqv @gw_curr)
if [ "$cur" != "$stored" ]; then
  tmux set-option -g @gw_prev "$stored"
  tmux set-option -g @gw_curr "$cur"
fi
