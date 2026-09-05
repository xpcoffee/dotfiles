# Claude Code configuration

How this directory maps into `~/.claude/`, and how work (private) config stays out of this public repo.

## Files

| Repo file | Where it lands | Committed? | Scope |
|-----------|----------------|------------|-------|
| `settings.json` | merged into `~/.claude/settings.json` | yes (public base) | user / global |
| `work-settings.json` | merged into `~/.claude/settings.json` | no (`work-*`, gitignored) | user / global |
| `settings.local.json` | `~/.claude/settings.local.json` (stow symlink) | no (gitignored) | this repo's project only |
| `mcp_settings.json` | `~/.claude/mcp_settings.json` (stow symlink) | yes | — |
| `agents/`, `skills/`, `commands/` | `~/.claude/...` (stow symlink) | yes, except `work-*` entries | — |
| `writing/ai-isms.md` | `~/.claude/writing/ai-isms.md` (stow symlink) | yes | — |
| `../claude-md/CLAUDE.md` | `~/CLAUDE.md` (stow symlink, `$HOME` target) | yes | user / global |

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

## `~/CLAUDE.md` lives in the `claude-md/` package

`~/CLAUDE.md` is the instruction file Claude reads for any working directory under `$HOME`. It targets `$HOME`, not `$HOME/.claude`, so it cannot sit in this directory's stow package. It has its own package, `claude-md/`, listed in `install.sh` alongside `tmux` and `zsh`.

The repo root already has its own `CLAUDE.md` holding instructions for working on the dotfiles repo itself. The two are unrelated.

## What stays out of the public repo

This repo is public, so anything committed here is readable by anyone. Two writing files split along that line:

- `writing/ai-isms.md` (here, public) holds the curated prose rules. Every bad/good example is rewritten onto a neutral domain: accounts, sessions, jobs, regions, AdminUI and SupportUI.
- `writing/ai-isms-inbox.md` and `writing/ai-isms-fold-in.md` (private notes repo) hold raw sightings and the writing-style skill backlog. Sightings are verbatim text from real drafts and carry work detail.

`/ism-review` is the command that crosses the line, so it carries the sanitising step and the substitution table. Adding an example to `writing/ai-isms.md` that names a real system, ticket, colleague, or customer figure publishes it.

## Marketplaces

Plugin marketplaces are registered in `~/.claude.json` (private, not in this repo) via:

    claude plugin marketplace add <owner/repo>

Enablement is what this setup keeps private, via `work-settings.json`. Registration is already private in `~/.claude.json`.

Point `marketplace add` at a git clone and you get a GitHub marketplace: Claude Code
reads the directory's git remote, registers that remote as the source, and clones the
default branch. Plugins that live only on a local branch stay out of the catalogue,
and `plugin install` reports them as not found in the marketplace.

Removing a marketplace leaves its clone behind under
`~/.claude/plugins/marketplaces/<name>`. A stale clone there serves the same
marketplace name and hides the registration you meant to replace, so delete the
directory alongside `claude plugin marketplace remove <name>`.

## Plugins you edit locally

Symlink the plugin directory into `~/.claude/skills/`, one symlink per plugin:

    ln -sfn <repo>/plugins/<plugin> ~/.claude/skills/<plugin>

Any directory there holding a `.claude-plugin/plugin.json` loads as
`<plugin>@skills-dir`. Confirm with `claude plugin list`, which groups them under
"Skills-directory plugins". Claude Code reads the working tree directly, so an edit
takes effect on the next session, and the plugin needs no marketplace, no version
bump and no `enabledPlugins` entry. Keep the symlink targets out of this repo: they
name work paths.

Install the same plugin from a marketplace as well and both copies load, at whatever
version each holds. That is how a published `writing-style` 1.3.0 ended up shadowing
1.5.0 in the working tree.

Claude Code refuses every plugin in a marketplace that reaches its sources through a
symlink. It resolves each `source` path and rejects any path that leaves the
marketplace directory: `Plugin source path refused: ./plugins/<name> does not stay
inside its marketplace directory`. The refusal is written only to
`~/.claude/debug/latest`, so the plugins go missing with no visible error.

## Enabling a plugin

- **Work / private plugin** → add to `work-settings.json` `enabledPlugins`, then `claude-build-settings`.
- **Public / personal plugin** → add to `settings.json` `enabledPlugins` (it's committed).

Avoid `claude plugin enable <plugin> --scope user`: it writes the live `~/.claude/settings.json` directly. That no longer leaks (the live file isn't this repo), but the next rebuild overwrites it, so the change is lost unless it's also in `settings.json` or `work-settings.json`. Edit the source and rebuild instead.

## Windows

`install.sh` needs stow and a POSIX `$HOME`, so it cannot install this on Windows.
The Windows desktop app and CLI read `%USERPROFILE%\.claude`, which WSL's
`~/.claude` never touches — a WSL install leaves the Windows side with no config
at all. `install.ps1` covers the Claude Code packages there:

    pwsh -File install.ps1

It creates native symlinks for `commands/`, `skills/`, `agents/`, `writing/` and
`mcp_settings.json`, and generates `~/.claude/settings.json` the way
`bin/claude-build-settings` does. Developer Mode is enough to create the links;
no elevation is needed. Anything already at a link path that is not a symlink is
moved to `.bak` rather than replaced.

Two deliberate differences from the Linux install:

- `CLAUDE.md` is linked to `~/.claude/CLAUDE.md`, not `~/CLAUDE.md`. The Linux
  setup relies on the walk up from a cwd under `$HOME`; the user-scope path
  applies to repos on other drives too.
- A third overlay, `windows-settings.json` (public, committed — it holds no work
  material), is merged last so its path fixes win over the Linux paths in the
  base and in `work-settings.json`. A `null` there deletes the key, which is how
  `extraKnownMarketplaces` and `enabledPlugins` are dropped: both name Linux
  paths and a marketplace that is not registered on Windows.
