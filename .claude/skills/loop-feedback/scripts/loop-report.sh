#!/usr/bin/env bash
# Summarise how the loop system is doing, from ~/.claude/loops.
set -euo pipefail
LOOPS="${LOOPS_DIR:-$HOME/.claude/loops}"

shopt -s nullglob
outcomes=("$LOOPS"/*/outcome.json)
if [ ${#outcomes[@]} -eq 0 ]; then
  echo "No finished loops in $LOOPS yet."
  exit 0
fi

echo "== Loops by verdict"
jq -s 'group_by(.user_verdict) | map({verdict: .[0].user_verdict, loops: length})' "${outcomes[@]}"

echo "== Loops by stop reason"
jq -s 'group_by(.stop_reason) | map({stop_reason: .[0].stop_reason, loops: length})' "${outcomes[@]}"

echo "== Rejected although every check passed (the checks missed the intent)"
jq -s '[.[] | select(.stop_reason == "checks-pass" and .user_verdict == "rejected")] | length' "${outcomes[@]}"

if [ -f "$LOOPS/misses.jsonl" ]; then
  echo "== Rejections by failed part"
  jq -s 'group_by([.task_type, .part]) | map({task_type: .[0].task_type, part: .[0].part, misses: length, unproven: map(select(.proven != "yes")) | length})' "$LOOPS/misses.jsonl"
fi
