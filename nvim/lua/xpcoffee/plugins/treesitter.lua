return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",        -- update parsers,
  dependencies = {
    "windwp/nvim-ts-autotag", -- autoclose tags
  },
  config = function()
    local treesitter = require("nvim-treesitter.configs")
    local parsers = require("nvim-treesitter.parsers")

    treesitter.setup({
      highlight = {
        enable = true, -- syntax
        disable = function(lang, buf)
          local bufname = vim.api.nvim_buf_get_name(buf)
          local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
          return buftype == 'nofile' or bufname:match("noice")
        end,
      },
      indent = { enable = true },
      autotag = { enable = true }, -- requires plugin
      -- languages we want to autoinstall
      ensure_installed = {
        "bash",
        "css",
        "c_sharp",
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
        "markdown_inline",
        "rust",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<cr>",
          node_incremental = "<cr>",
          scope_incremental = false,
          node_decremental = "<bs>",
        }
      },
    })

    vim.treesitter.language.register('c_sharp', 'csharp')
    vim.treesitter.language.register('c_sharp', 'cs')
    vim.treesitter.language.register('markdown', 'mdx')
  end
}
