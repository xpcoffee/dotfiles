return {
    "nvim-treesitter/nvim-treesitter",  
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate", -- update parsers,
    dependencies = {
        "windwp/nvim-ts-autotag", -- autoclose tags
    },
    config = function()
        local treesitter = require("nvim-treesitter.configs")

        treesitter.setup({
            highlight = { enable = true }, -- syntax
            indent = { enable = true },
            autotag = { enable = true }, -- requires plugin
            -- languages we want to autoinstall
            ensure_installed = {
                "bash",
                "css",
                "dockerfile",
                "gitignore",
                "graphql",
                "html",
                "java",
                "javascript",
                "jq",
                "json",
                "kotlin",
                "lua",
                "markdown",
                "rust",
                "tsx",
                "typescript",
                "vim",
                "yaml",
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<leader>s",
                    node_incremental = "<leader>s",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                }
            }
        })
    end
}
