-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Lazy package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- languages
	{ 'neoclide/coc.nvim', branch = 'release'},
	'williamboman/mason.nvim',
	'williamboman/mason-lspconfig.nvim',

	-- appearance
	'nvim-lua/plenary.nvim',
    	'vim-airline/vim-airline',
    	'airblade/vim-gitgutter',
	'nordtheme/vim',

	-- editing
	'Lokaltog/vim-easymotion',

	-- file management
	'nvim-tree/nvim-tree.lua', -- file drawer
	'nvim-tree/nvim-web-devicons',
	'elihunter173/dirbuf.nvim', -- edit filesystem like a normal buffer
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.6', -- omnibar
		dependencies = { 'nvim-lua/plenary.nvim' }
	},

	-- integrations
	'christoomey/vim-tmux-navigator',
})



--
-- Appearance
--
vim.opt.termguicolors = true
vim.cmd [[colorscheme nord]]

--
-- Keybindings
--

vim.g.mapleader = ","

-- custom commands
vim.keymap.set("n", "<leader>v", ":e ~/.config/nvim/init.lua<CR>")

-- easymotion
vim.keymap.set("n", "<space>", "<Plug>(easymotion-prefix)")
vim.keymap.set("n", "f", "<Plug>(easymotion-f)")
vim.keymap.set("n", "F", "<Plug>(easymotion-F)")
vim.keymap.set("n", "t", "<Plug>(easymotion-t)")
vim.keymap.set("n", "T", "<Plug>(easymotion-T)")

-- telescope
local telescope = require('telescope.builtin')
vim.keymap.set("n", "<C-p>", telescope.find_files, {})
vim.keymap.set("n", "<C-M-p>", telescope.live_grep, {})

-- dirbuf & nvim-tree
local nvimtree = require "nvim-tree.api"
require("nvim-tree").setup({
	view = {
		width = 50
	}
})
vim.keymap.set("n", "<C-b>", nvimtree.tree.toggle, {})
vim.keymap.set("n", "<C-M-b>", "<Plug>(dirbuf_toggle_hide)")

-- coc
-- use <tab> for trigger completion and navigate to the next complete item
-- https://github.com/neoclide/coc.nvim/wiki/Completion-with-sources#use-tab-or-custom-key-for-trigger-completion
vim.cmd [[
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
]]
