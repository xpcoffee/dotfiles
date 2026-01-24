# AGENTS.md

Guidelines for AI agents working with this dotfiles repository.

## General Principles

- This is a personal configuration repo. Changes should be conservative and well-tested.
- Prefer editing existing files over creating new ones.
- Keep solutions simple; avoid over-engineering.

## Neovim Configuration

### Plugin Philosophy

**Prefer existing plugins and core vim features over adding new plugins.**

Before suggesting a new plugin:

1. Check if an existing plugin already provides the functionality (see `nvim/lua/xpcoffee/plugins/`)
2. Consider if core Neovim features can solve the problem
3. If a new plugin is truly needed, discuss it first

### Keymaps

- Leader key is `,` (comma) - preserve this convention
- All new keymaps must include a `desc` field for which-key integration
- Follow the existing group conventions:
  - `<leader>b` - buffer operations
  - `<leader>l` - logs/messages
  - Check existing plugins for their keymap patterns before adding related functionality

Example of proper keymap format:

```lua
keymap.set("n", "<leader>xx", "<cmd>SomeCommand<CR>", { desc = "Description here" })
```

### File Organization

```
nvim/
├── init.lua                      # Entry point (don't modify unless necessary)
├── lua/xpcoffee/
│   ├── core/
│   │   ├── init.lua              # Loads core modules
│   │   ├── options.lua           # Vim options (tabs, search, etc.)
│   │   ├── keymaps.lua           # Global keymaps not tied to plugins
│   │   └── filetypes.lua         # Filetype-specific settings
│   ├── plugins/
│   │   ├── init.lua              # Base plugins (plenary, tmux-navigator)
│   │   ├── lsp/                  # LSP configurations (mason, lspconfig)
│   │   └── [plugin].lua          # One file per plugin
│   ├── lazy.lua                  # lazy.nvim setup
│   └── vscode.lua                # VSCode-specific config (when using vscode-neovim)
```

- Plugin configs go in `lua/xpcoffee/plugins/` as individual files
- LSP-related configs go in `lua/xpcoffee/plugins/lsp/`
- Core settings that aren't plugin-specific go in `lua/xpcoffee/core/`

### Code Style

- Use 2-space indentation (matches the vim config itself)
- Use `local` for module-scoped variables
- Return a table `M` or a lazy.nvim plugin spec from each module

### Testing Changes

After modifying nvim config:

1. Save all changes
2. Restart Neovim completely (`:qa` then reopen)
3. Check `:messages` for any errors
4. Run `:checkhealth` if adding LSP or plugin dependencies
5. Verify keymaps appear correctly in which-key (press leader and wait)
6. Test the functionality itself. If needed create a test file and then run operations on it to confirm.
7. Look in `Testing.md` for approaches to testing changes. If there are none, start it. If none make sense, try and append if it works.

## Other Configurations

### Shell Configs (bash, zsh, fish)

- Keep shell-specific config in their respective directories
- Common aliases can be shared via sourcing

### Git Config

- Global gitignore patterns go in `git/.gitignore`
- Be cautious with gitconfig changes as they affect all repos

### Tmux

- The nvim config includes tmux-navigator integration
- Tmux and nvim navigation keybindings should remain compatible
