vim.g.mapleader = ","

local keymap = vim.keymap -- for conciseness

keymap.set("n", "<leader>v", ":e ~/.config/nvim/init.lua<CR>", { desc = "Open root init.lua" })
