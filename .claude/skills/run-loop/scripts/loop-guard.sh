#!/usr/bin/env bash
# PreToolUse guard for the loop agents, registered in user settings so it also fires inside
# Workflow agents, where agent-file hooks do not. It acts only when the calling agent is
# loop-optimizer, loop-implementer or loop-evaluator, and allows every other caller.
# Blocks the optimizer and implementer from reading the hidden checks, and blocks file edits
# outside a working directory the main session registered for a running loop.
# Pattern matching on tool input stops accidents, not a determined agent.
set -uo pipefail
input="$(cat)"
agent="$(jq -r '.agent_type // ""' <<<"$input")"
[[ "$agent" =~ ^([a-z0-9_-]+:)?loop-(optimizer|implementer|evaluator)$ ]] || exit 0
role="${BASH_REMATCH[2]}"
tool="$(jq -r '.tool_name // ""' <<<"$input")"
active="${LOOPS_DIR:-$HOME/.claude/loops}/active-workdirs"

block() { echo "loop-guard ($role): $1" >&2; exit 2; }

if [[ "$role" != "evaluator" ]] && jq -e '[.tool_input | .. | strings] | any(test("holdout\\.md"))' <<<"$input" >/dev/null; then
  block "the hidden checks in holdout.md are for the evaluator only; steer by the intent in charter.md"
fi

case "$tool" in
  Write|Edit|MultiEdit|NotebookEdit)
    path="$(jq -r '.tool_input.file_path // .tool_input.notebook_path // ""' <<<"$input")"
    [[ -n "$path" ]] || block "no file path on $tool"
    path="$(realpath -m -- "$path")"
    [[ -f "$active" ]] || block "no loop working directory is registered in $active"
    while IFS= read -r dir; do
      [[ -z "$dir" ]] && continue
      dir="$(realpath -m -- "$dir")"
      [[ "$path" == "$dir" || "$path" == "$dir"/* ]] && exit 0
    done <"$active"
    block "$path is outside the registered loop working directories"
    ;;
esac
exit 0
