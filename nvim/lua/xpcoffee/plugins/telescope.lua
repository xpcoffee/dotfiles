return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-tree/nvim-web-devicons",
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
        local telescope = require('telescope.builtin')
        vim.keymap.set("n", "<leader>ff", telescope.find_files, {})
        vim.keymap.set("n", "<leader>fg", telescope.live_grep, {})
    end
}
