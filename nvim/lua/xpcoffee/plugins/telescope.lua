return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-tree/nvim-web-devicons",
        "folke/which-key.nvim",
    },
    config = function()
        local telescope = require("telescope")

        telescope.setup({
            defaults = {
                path_display = { "smart" }
            }
        })

        telescope.load_extension("fzf")

        -- keymaps
        local builtins = require('telescope.builtin')
        require("which-key").register({ ["<leader>f"] = { name = "+files" } })
        vim.keymap.set('n', '<leader>ff', builtins.find_files, { desc = 'Find file' })
        vim.keymap.set('n', '<leader>fg', builtins.live_grep, { desc = 'Grep through files' })
        vim.keymap.set('n', '<leader>fb', builtins.buffers, { desc = 'Find buffer' })
    end
}
