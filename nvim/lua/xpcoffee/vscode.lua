vim.g.mapleader = ","

local opt = vim.opt

opt.number = true
vim.wo.relativenumber = true
opt.cursorline = true

-- indendations
opt.tabstop = 2
opt.shiftwidth = 2
opt.autoindent = true
vim.cmd("set expandtab")

-- searching
opt.ignorecase = true
opt.smartcase = true -- don't ignore case if you have mixed case in search

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus") -- system clipboard as default register

vim.keymap.set('n', '<C-e>', function()
  print("hello world")
  require('vscode').action('workbench.action.openRecent')
end)

--
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

require("lazy").setup(
  {
    spec = {
      { import = "xpcoffee.plugins.flash" },
      { import = "xpcoffee.plugins.treesitter" }
    }
  }
)
