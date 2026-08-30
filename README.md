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
- `install.sh` - Installation script using GNU stow
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

The install script uses [`GNU stow`](https://www.gnu.org/software/stow/manual/stow.html) uses it to link config.

* For mac: you can use `brew install stow` to install GNU stow.
* For linux: the script gets installed automatically ⚠


## Getting started

**Run the install script**

```shell
./install.sh
```

This will create simlinks to `~` and `~/.config/`, depending on the config.
    
If there was already a file existing for one of these files, the script will 'adopt' files that currently exist, and log out which files this has happened for.

  * This repo is version-controlled, so you can use `git diff` locally to see the difference between any files that have been adopted and what this repo contains.
  * You can then decide what to keep or revert.
  * Commit any changes so that they can be re-used in future.

For more tooling and steps to do after installing config see [the wiki](https://github.com/xpcoffee/dotfiles/wiki).
