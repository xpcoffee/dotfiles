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
	'joshdick/onedark.vim',

	-- editing
	'Lokaltog/vim-easymotion',

	-- file management
	'preservim/nerdtree',
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.6',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},

	-- integrations
	'christoomey/vim-tmux-navigator',
})

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
