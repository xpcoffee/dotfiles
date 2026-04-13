---
name: find-keybinding
description: Find an available keybinding that won't conflict with existing bindings across tmux, neovim, and shell configs in this dotfiles repo. Use when adding a new hotkey or shortcut.
disable-model-invocation: true
argument-hint: [context e.g. "tmux root-table binding for sesh last"]
allowed-tools: Bash(grep *) Read Grep Glob Agent
---

# Find an available keybinding

Find a non-conflicting keybinding for: $ARGUMENTS

## Steps

1. **Audit existing keybindings** across all configs in this dotfiles repo. Launch parallel Explore agents for each:

   - **tmux** (`tmux/.tmux.conf`): all `bind-key`, `bind`, `unbind` directives including root-table (`-n`) and prefix-table bindings. Note which plugins are loaded as they may claim keys (e.g. vim-tmux-navigator uses `C-h/j/k/l`).
   - **neovim** (`nvim/lua/xpcoffee/`): all `keymap.set` and `vim.keymap.set` calls across all lua files. Pay special attention to Ctrl combinations since these can conflict with terminal-level bindings.
   - **shell** (`bash/`, `zsh/`, `fish/`): any `bind`, `bindkey`, or keybinding config (e.g. fzf keybinding setup).

2. **Identify the binding scope** from the user's context (e.g. tmux root-table, tmux prefix-table, neovim normal mode, etc.)

3. **Build a conflict map** for that scope:
   - For **tmux root-table** (`bind-key -n`): these intercept keys before they reach nvim/shell, so also list Ctrl/Alt keys used in neovim and shell to avoid stealing them.
   - For **tmux prefix-table**: only check other tmux prefix bindings.
   - For **neovim**: check the specific mode (normal, insert, visual) and also note any tmux root-table bindings that would intercept the key first.

4. **Propose 2-3 candidates** ranked by:
   - Mnemonic fit (e.g. `M-s` for sesh, `C-g` for git)
   - Consistency with existing conventions in the config (e.g. if Alt+Shift is used for splits, prefer Alt for related actions)
   - Ergonomics (easy to reach, not awkward combos)

5. **Present a summary**: show the conflict map and your ranked proposals with rationale. Let the user choose.
