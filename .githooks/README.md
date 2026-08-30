# Git hooks for this repo

`install.sh` points this repo at these hooks with `git config core.hooksPath .githooks`. The setting is repo-local, so it does not affect any other repo.

## pre-commit

This repo is public. The hook fails a commit whose staged **added lines or filenames** match any regex in `.githooks/work-patterns`, so work / employer material cannot reach the remote by accident.

`work-patterns` is not committed: it matches the `work-*` rule in `.gitignore`, which keeps the patterns themselves local. One extended regex per line; blank lines and `#` comments are skipped. Without the file the hook prints a notice and passes, so a fresh clone still works.

Create it after cloning:

    cat > .githooks/work-patterns <<'PATTERNS'
    my-employer
    my-employer-domain\.com
    PATTERNS

When the hook fires, move the content to the private overlay rather than bypassing it:

| Content | Goes to |
|---------|---------|
| git config | `~/.gitconfig-work` (included for repos under `~/code/work/`) |
| Claude settings | `.claude/work-settings.json`, then `claude-build-settings` |
| anything else | a `work-*` path |

`git commit --no-verify` skips the check when a match is a false positive.
