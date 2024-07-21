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

        local builtins = require('telescope.builtin')
        local function live_grep_selection()
            local selection = vim.fn.getregion(
                vim.fn.getpos("v"),
                vim.fn.getpos(".")
            )

            builtins.live_grep {
                default_text = table.concat(selection)
            }
        end

        -- keymaps
        require("which-key").add({ "<leader>f", group = "files" })
        vim.keymap.set('n', '<leader>ff', builtins.find_files, { desc = 'Find file' })
        vim.keymap.set('n', '<leader>fg', builtins.live_grep, { desc = 'Grep through files' })
        vim.keymap.set('v', '<leader>fg', live_grep_selection, { desc = 'Grep through files' })
        vim.keymap.set('n', '<leader>fb', builtins.buffers, { desc = 'Find buffer' })
    end
}
