#!/usr/bin/env bash
# Fill the review page template from a review packet: render-review.sh <packet.json> <out.html>
set -euo pipefail
packet="$1"; out="$2"
template="$(dirname "$0")/../templates/review.html"

title="$(jq -r '.title' "$packet")"
# "</" inside the embedded JSON would close its <script> element early.
json="$(jq -c . "$packet" | sed 's#</#<\\/#g')"

TITLE="$title" JSON="$json" python3 -I -c '
import os, sys
html = open(sys.argv[1]).read()
html = html.replace("__TITLE__", os.environ["TITLE"].replace("<", "&lt;"), 1).replace("__PACKET__", os.environ["JSON"], 1)
open(sys.argv[2], "w").write(html)
' "$template" "$out"
echo "$out"
