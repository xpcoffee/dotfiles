return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    print("mason-lspconfig config")
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    mason_lspconfig.setup({
      ensure_installed = {
        "bashls",
        "html",
        "lua_ls",
        "marksman",
        "rust_analyzer",
        "tailwindcss",
        "ts_ls",
        "csharp_ls"
      },
      handlers = {
        function(server_name)
          local capabilities = cmp_nvim_lsp.default_capabilities()
          lspconfig[server_name].setup({
            capabilities = capabilities,
          })
        end,
        ["ts_ls"] = function()
          lspconfig.ts_ls.setup {
            filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
            cmd = { "typescript-language-server", "--stdio" }
          }
        end,
        ["lua_ls"] = function()
          local capabilities = cmp_nvim_lsp.default_capabilities()
          lspconfig["lua_ls"].setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
              }
            }
          })
        end
      }
    })

    local keymap = vim.keymap
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        opts.desc = "Show LSP references"
        keymap.set("n", "fr", "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "Show code actions"
        keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, opts)
        keymap.set({ "n", "v" }, "<C-a>", vim.lsp.buf.code_action, opts)

        opts.desc = "Show diagnostic message"
        keymap.set({ "n", "v" }, "<leader>m", vim.diagnostic.open_float, opts)

        opts.desc = "Jump to definition"
        keymap.set({ "n", "v" }, "<leader>d", vim.lsp.buf.definition, opts)

        opts.desc = "Jump to implementation"
        keymap.set({ "n", "v" }, "<leader>i", vim.lsp.buf.implementation, opts)

        opts.desc = "Rename"
        keymap.set({ "n" }, "<leader>cr", vim.lsp.buf.rename, opts)

        opts.desc = "Show incoming calls"
        keymap.set({ "n", "v" }, "<leader>cfi", vim.lsp.buf.incoming_calls, opts)

        opts.desc = "Show outgong calls"
        keymap.set({ "n", "v" }, "<leader>cfo", vim.lsp.buf.outgoing_calls, opts)
      end
    })
  end,
}
