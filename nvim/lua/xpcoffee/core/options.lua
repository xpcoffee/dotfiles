local opt = vim.opt

opt.number = true
opt.cursorline = true

-- indendations
opt.tabstop = 4
opt.shiftwidth = 4
opt.autoindent = true
vim.cmd("set expandtab")

-- searching
opt.ignorecase = true
opt.smartcase = true -- don't ignore case if you have mixed case in search

-- basic appearance
opt.termguicolors = true
opt.background = "dark" -- use dark mode if the theme supports both light and dark

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus") -- system clipboard as default register
