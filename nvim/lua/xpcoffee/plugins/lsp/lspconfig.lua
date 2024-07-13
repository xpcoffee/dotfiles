return {
    "neovim/nvim-lspconfig",
    -- needs to run after Mason, which is not lazy loaded
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",                                   -- completion integration
        { "antosha417/nvim-lsp-file-operations", config = true }, -- rname imports on file name changes
        { "folke/neodev.nvim",                   opts = {} }      -- better lua lsp for vim config
    },
    config = function()
        local lspconfig = require("lspconfig")
        local mason_lspconfig = require("mason-lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        keymap = vim.keymap -- for conciseness

        -- run on event
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                -- mappings that apply only in the buffer where an LSP has attached
                local opts = { buffer = ev.buf, silent = true }

                opts.desc = "Show LSP references"
                keymap.set("n", "fr", "<cmd>Telescope lsp_references<CR>", opts)

                opts.desc = "See available code actions"
                keymap.set({ "n" }, "<leader>gd", vim.lsp.buf.definition, opts)

                require("which-key").register({ ["<leader>a"] = { name = "+actions" } })

                opts.desc = "See available code actions"
                keymap.set({ "n", "v" }, "<leader>aa", vim.lsp.buf.code_action, opts)

                opts.desc = "Show diagnostic message"
                keymap.set({ "n", "v" }, "<leader>ad", vim.diagnostic.open_float, opts)

                opts.desc = "Rename"
                keymap.set({ "n" }, "<leader>ar", vim.lsp.buf.rename, opts)
            end

        })

        -- enable autocompletion on every type of server
        local capabilities = cmp_nvim_lsp.default_capabilities()
        mason_lspconfig.setup_handlers({
            function(server_name)
                lspconfig[server_name].setup({
                    capabilities = capabilities,
                })
            end,
            ["tsserver"] = function()
                lspconfig.tsserver.setup {
                    filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
                    cmd = { "typescript-language-server", "--stdio" }
                }
            end,
            ["lua_ls"] = function()
                lspconfig["lua_ls"].setup({
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { "vim" }, -- lua LSP understand vim global variable
                            },
                        }
                    }
                })
            end,
        })
    end,

}
