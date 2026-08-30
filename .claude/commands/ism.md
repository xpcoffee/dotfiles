---
description: Capture an AI-ism (a phrase or sentence shape in AI prose worth correcting) to the inbox
argument-hint: [offending phrase] [-> rewrite]
allowed-tools: Bash
---

Append one AI-ism sighting to `~/code/personal/notes/writing/ai-isms-inbox.md`.

The inbox is in the private notes repo, not in dotfiles, because a sighting is verbatim text from a real draft and often carries work detail. Record it verbatim here; `/ism-review` is what rewrites it onto a neutral domain before it reaches the public curated list.

Input: `$ARGUMENTS`

## What to record

- **The phrase.** If `$ARGUMENTS` contains it, use that. If `$ARGUMENTS` is empty or only gestures at it ("that last sentence", "the closing line"), take the text verbatim from the most recent assistant message in this conversation.
- **The rewrite.** Use whatever follows `->` in `$ARGUMENTS`. If the user gave none, write `-`. Do not invent one.
- **The source.** The repo or task you are currently in, in a few words: `notes: interview report`, `backend: PR body`, `chat reply`.
- **The date.** Get it from `date +%F`.

## How to write it

Append exactly one line, in this shape:

```
- YYYY-MM-DD | <pattern named in a few words> | "<bad text verbatim>" | "<rewrite or ->" | <source>
```

Escape any `|` inside quoted text as `\|`. Create the file with a `# AI-isms inbox` heading if it does not exist.

## What not to do

Do not read or edit `~/.claude/writing/ai-isms.md`. Do not check for duplicates, merge with an existing entry, judge whether the ism is real, or promote anything. Curation is a separate pass; this command only captures. Do not commit.

Then reply with one line: the pattern you recorded and nothing else. The user is mid-task on something else.
