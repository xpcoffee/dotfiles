#!/bin/bash

# Create a tmux window for each git worktree

# Get repo name from git
REPO_NAME=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null)
if [[ -z "$REPO_NAME" ]]; then
    echo "Not in a git repository"
    exit 1
fi

SESSION_NAME="$REPO_NAME"

# Get worktree paths using wt command, strip ANSI codes, keep only paths
WORKTREES=$(wt list 2>/dev/null || wt 2>/dev/null)
WORKTREES=$(echo "$WORKTREES" | sed 's/\x1b\[[0-9;]*m//g' | grep '^/')

if [[ -z "$WORKTREES" ]]; then
    echo "No worktrees found or wt command failed"
    exit 1
fi

# Get window name: use branch name for main/master, otherwise directory name
get_window_name() {
    local wt_path="$1"
    local branch
    branch=$(git -C "$wt_path" rev-parse --abbrev-ref HEAD 2>/dev/null)

    if [[ "$branch" == "main" || "$branch" == "master" ]]; then
        echo "$branch"
    else
        basename "$wt_path"
    fi
}

# Collect worktrees into arrays
declare -a WT_PATHS
declare -a WT_NAMES

while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    WT_PATH=$(echo "$line" | awk '{print $1}')
    WT_PATHS+=("$WT_PATH")
    WT_NAMES+=("$(get_window_name "$WT_PATH")")
done <<< "$WORKTREES"

# Check if tmux session exists
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo "Session '$SESSION_NAME' already exists"
    exit 1
fi

# Create session with placeholder window
tmux new-session -d -s "$SESSION_NAME"

# Create a window for each worktree
for ((i=0; i<${#WT_PATHS[@]}; i++)); do
    tmux new-window -t "$SESSION_NAME" -n "${WT_NAMES[$i]}" -c "${WT_PATHS[$i]}"
done

# Kill the initial placeholder window and select first worktree
tmux kill-window -t "$SESSION_NAME:0"
tmux select-window -t "$SESSION_NAME:1"

# Attach to session if not already in tmux
if [[ -z "$TMUX" ]]; then
    tmux attach-session -t "$SESSION_NAME"
else
    tmux switch-client -t "$SESSION_NAME"
fi

echo "Created tmux session '$SESSION_NAME' with worktree windows"
