vim.g.mapleader = ","

local keymap = vim.keymap -- for conciseness

keymap.set("n", "<leader>v", ":e ~/.config/nvim/init.lua<CR>", { desc = "Open root init.lua" })

keymap.set("n", "<leader>bn", "<cmd>bn<CR>", { desc = "Next buffer" })
keymap.set("n", "<leader>bp", "<cmd>bp<CR>", { desc = "Previous buffer" })
