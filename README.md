# dotfiles

This repo maintains a collection of configuration files that I use, as well as utilities to set things up.

## Structure

- `bash/` - Bash shell configuration (.bashrc)
- `fish/` - Fish shell configuration
- `git/` - Git configuration (.gitconfig, .gitignore)
- `nvim/` - Neovim configuration (Lua-based, using lazy.nvim)
  - `lua/xpcoffee/core/` - Core settings (options, keymaps, filetypes)
  - `lua/xpcoffee/plugins/` - Plugin configurations
  - `lua/xpcoffee/plugins/lsp/` - LSP-specific configurations
- `tmux/` - Tmux configuration (.tmux.conf)
- `zsh/` - Zsh shell configuration (.zshrc, .aliases, .profile)
- `komorebi/` - Windows tiling window manager (komorebi + whkd); see [komorebi/README.md](komorebi/README.md). Not stowed — has its own `install.ps1`.
- `hypr/` - Hyprland keybindings and workspace routing for omarchy, kept in sync with `komorebi/`. Not stowed; folded into omarchy's own config by hand.
- `install.sh` - Installation script using GNU stow, for Linux, macOS and WSL
- `install.ps1` - Windows counterpart, covering the Claude Code config only; GNU stow is not available there
- `.githooks/` - Repo-local git hooks; `pre-commit` keeps work config out of this public repo (see [.githooks/README.md](.githooks/README.md))

## Public repo, private overlays

This repo is public, so employer-specific config never lives in it. Each area has a private counterpart that stays on the machine:

| Public, committed | Private, local only |
|-------------------|---------------------|
| `git/.gitconfig` | `~/.gitconfig-work`, pulled in by an `includeIf gitdir:~/code/work/` |
| `.claude/settings.json` | `.claude/work-settings.json`, merged by `bin/claude-build-settings` (see [.claude/README.md](.claude/README.md)) |
| anything else | any `work-*` path, which `.gitignore` excludes |

The `pre-commit` hook fails the commit if work material is staged anyway.

## Pre-requisies

`install.sh` uses [`GNU stow`](https://www.gnu.org/software/stow/manual/stow.html) to link config. The Windows scripts do not need it.

* For mac: you can use `brew install stow` to install GNU stow.
* For linux: the script gets installed automatically ⚠


## Getting started

Which scripts to run depends on the machine.

| Machine | Run, in order |
|---|---|
| Linux, macOS, WSL | `./install.sh` |
| Windows | `.\install.ps1`, then `komorebi\install.ps1` |
| omarchy (Arch + Hyprland) | `./install.sh`, then fold `hypr/tiling-consistency.conf` into your Hyprland config by hand |

### Linux, macOS and WSL

**Run the install script**

```shell
./install.sh
```

This will create simlinks to `~` and `~/.config/`, depending on the config.

If there was already a file existing for one of these files, the script will 'adopt' files that currently exist, and log out which files this has happened for.

  * This repo is version-controlled, so you can use `git diff` locally to see the difference between any files that have been adopted and what this repo contains.
  * You can then decide what to keep or revert.
  * Commit any changes so that they can be re-used in future.

### Windows

GNU stow is not available here, so two PowerShell scripts stand in. Neither needs admin rights.

```powershell
.\install.ps1           # Claude Code config: symlinks into ~\.claude, generates settings.json
.\komorebi\install.ps1  # tiling window manager: installs komorebi + whkd, points them at this repo, starts them, registers autostart at login
```

The root `install.ps1` covers the Claude Code config only. Shell, nvim and tmux config are not installed on Windows; those run under WSL, where `./install.sh` applies.

[komorebi/README.md](komorebi/README.md) covers the prerequisites, the keybindings, and the escape hatch for games that need the Alt key back.

### Tiling window manager

Both operating systems run the same tiling setup: nine workspaces, the same binding layout (`hjkl` to focus, `+Shift` to move, numbers to switch workspace), and the same workspace themes. Only the modifier key differs, Alt on Windows and Super on Linux, for the reason [komorebi/README.md](komorebi/README.md) gives.

Workspaces 1-4 have a theme and open their apps automatically. 5-9 are unassigned scratch space.

| Workspace | Theme | Windows (komorebi) | Linux (Hyprland) |
|---|---|---|---|
| 1 | Comms | WhatsApp, Teams, Discord, Slack | Slack, Discord, Signal, plus the WhatsApp and Teams web apps |
| 2 | Reading & research | Edge | Chromium |
| 3 | Coding / technical | Windows Terminal, VS Code | Alacritty, kitty, ghostty or foot; VS Code |
| 4 | Recreational | Spotify, Steam | Spotify, Steam |

The rules that do the routing live in two places: `workspace_rules` in [komorebi/komorebi.json](komorebi/komorebi.json), and the workspace-routing section at the end of [hypr/tiling-consistency.conf](hypr/tiling-consistency.conf). Putting a new app on a workspace means editing both, because the two window managers match on different things: komorebi on the Windows executable name, Hyprland on the Wayland window class.

The two also behave differently once a window is placed. komorebi re-sends a matching window to its workspace every time, so dragging it elsewhere does not stick. Hyprland places the window when it opens and then leaves it alone, so the drag does stick.

**No script installs the Linux side.** omarchy owns `~/.config/hypr` and rewrites it on `omarchy-update`, so `hypr/tiling-consistency.conf` is a reference to fold into your own Hyprland user config rather than something to symlink. Its header comment says where the contents go and how to check that your omarchy version still uses that convention.

For more tooling and steps to do after installing config see [the wiki](https://github.com/xpcoffee/dotfiles/wiki).
