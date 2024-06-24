return {
    "ThePrimeagen/harpoon",
    dependencies = {
        "nvim-lua/plenary.nvim"
    },
    config = function()
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")
        local term = require("harpoon.term")
        require("which-key").register({ ["<leader>h"] = { name = "+harpoon" } })

        vim.keymap.set('n', '<leader>hm', mark.add_file, { desc = 'Harpoon Mark' })
        vim.keymap.set('n', '<leader>hh', ui.toggle_quick_menu, { desc = 'Harpoon Quick menu' })

        vim.keymap.set('n', '<leader>hr', function() ui.nav_file(1) end, { desc = 'Harpoon 1' })
        vim.keymap.set('n', '<leader>hf', function() ui.nav_file(2) end, { desc = 'Harpoon 2' })
        vim.keymap.set('n', '<leader>hv', function() ui.nav_file(3) end, { desc = 'Harpoon 3' })
        vim.keymap.set('n', '<leader>hc', function() ui.nav_file(4) end, { desc = 'Harpoon 4' })

        vim.keymap.set('n', '<leader>ht', function() term.gotoTerminal(1) end, { desc = 'Terminal' })

        vim.keymap.set('n', '<leader>hn', ui.nav_next, { desc = 'Harpoon next' })
        vim.keymap.set('n', '<leader>hp', ui.nav_prev, { desc = 'Harpoon previous' })
    end
}
