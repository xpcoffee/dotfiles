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

-- don't attempt to load perl things
vim.cmd("let g:loaded_perl_provider = 0")

-- remap escape in terminals
vim.cmd("tnoremap <Esc> <C-\\><C-n>")
