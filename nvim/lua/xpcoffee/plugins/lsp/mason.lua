return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local mason_tool_installer = require("mason-tool-installer")

        mason.setup({})
        mason_lspconfig.setup({
            ensure_installed = {
                "bashls",
                "graphql",
                "html",
                "jdtls", -- java lsp
                "kotlin_language_server",
                "lua_ls",
                "gopls",
                "rust_analyzer",
                "tailwindcss",
                "tsserver",
                "gopls"
            }
        })

        mason_tool_installer.setup({
            ensure_installed = {
                "prettier",
                "js-debug-adapter"
            }
        })
    end,
}
