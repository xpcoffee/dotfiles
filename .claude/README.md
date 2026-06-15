# Claude Code configuration

How this directory maps into `~/.claude/`, and how work (private) config stays out of this public repo.

## Files

| Repo file | Where it lands | Committed? | Scope |
|-----------|----------------|------------|-------|
| `settings.json` | merged into `~/.claude/settings.json` | yes (public base) | user / global |
| `work-settings.json` | merged into `~/.claude/settings.json` | no (`work-*`, gitignored) | user / global |
| `settings.local.json` | `~/.claude/settings.local.json` (stow symlink) | no (gitignored) | this repo's project only |
| `mcp_settings.json` | `~/.claude/mcp_settings.json` (stow symlink) | yes | — |
| `agents/`, `skills/` | `~/.claude/...` (stow symlink) | yes, except `work-*` entries | — |

## Why `settings.json` is generated, not symlinked

`~/.claude/settings.json` is the only file Claude reads at **user (global) scope**. This repo is public, so anything committed there is public. Work plugins need to be enabled globally and stay unpublished, and one committed file can't do both.

So `~/.claude/settings.json` is **generated**:

    ~/.claude/settings.json  =  settings.json        (public base, committed)
                              ⊕  work-settings.json   (private overlay, gitignored by work-*)

`bin/claude-build-settings` runs the merge (`jq -s '.[0] * .[1]'`, overlay wins). `install.sh` calls it after stow and passes `--ignore` so stow never symlinks or adopts `settings.json` / `work-settings.json`. The live file is a real file in `$HOME`, so it holds the work plugins without any of them touching this repo.

Rebuild after editing either source:

    claude-build-settings        # on PATH via bin/, or re-run install.sh

## `settings.local.json` is project-scoped, not global

Claude reads `.claude/settings.local.json` only when the working directory is inside the project that owns it. The `~/.claude/settings.local.json` symlink does **not** make it apply at user scope. Global private config goes in `work-settings.json`; this file is only for overrides while working in the dotfiles repo itself.

## Marketplaces

Plugin marketplaces are registered in `~/.claude.json` (private, not in this repo) via:

    claude plugin marketplace add <owner/repo>     # or a local directory path

Enablement is what this setup keeps private, via `work-settings.json`. Registration is already private in `~/.claude.json`.

## Enabling a plugin

- **Work / private plugin** → add to `work-settings.json` `enabledPlugins`, then `claude-build-settings`.
- **Public / personal plugin** → add to `settings.json` `enabledPlugins` (it's committed).

Avoid `claude plugin enable <plugin> --scope user`: it writes the live `~/.claude/settings.json` directly. That no longer leaks (the live file isn't this repo), but the next rebuild overwrites it, so the change is lost unless it's also in `settings.json` or `work-settings.json`. Edit the source and rebuild instead.
