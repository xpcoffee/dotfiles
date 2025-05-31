return {
  "neovim/nvim-lspconfig",
  -- needs to run after Mason, which is not lazy loaded
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",                                   -- completion integration
    { "antosha417/nvim-lsp-file-operations", config = true }, -- rname imports on file name changes
    { "folke/neodev.nvim",                   opts = {} },     -- better lua lsp for vim config
    {
      "folke/which-key.nvim",
      config = function()
        require("which-key").add({ "<leader>c", group = "code" })
        require("which-key").add({ "<leader>cf", group = "functions" })
      end
    },
  },
  config = function()
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap -- for conciseness

    -- run on event
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- mappings that apply only in the buffer where an LSP has attached
        local opts = { buffer = ev.buf, silent = true }

        opts.desc = "Show LSP references"
        keymap.set("n", "fr", "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "Show code actions"
        keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, opts)
        keymap.set({ "n", "v" }, "<C-a>", vim.lsp.buf.code_action, opts)

        opts.desc = "Show diagnostic message"
        keymap.set({ "n", "v" }, "<leader>m", vim.diagnostic.open_float, opts)

        -- Note: show information is <S-k> by default
        -- opts.desc = "Show information"
        -- keymap.set({ "n", "v" }, "<S-k>", vim.lsp.buf.hover, opts)

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

    -- enable autocompletion on every type of server
    local capabilities = cmp_nvim_lsp.default_capabilities()
    mason_lspconfig.setup_handlers({
      function(server_name)
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
      end
    })
  end
}
