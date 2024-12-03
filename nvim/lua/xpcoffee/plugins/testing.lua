return {
  "vim-test/vim-test",
  event = "VeryLazy",
  dependencies = {
    "folke/which-key.nvim",
  },
  config = function()
    require("which-key").add({ "<leader>t", group = "tests" })
    vim.keymap.set("n", "<leader>tt", "<cmd>TestNearest<CR>", { desc = "Run nearest test to cursor" })
  end
}
--
-- return {
--   "nvim-neotest/neotest",
--   -- event = "LspAttach",
--   dependencies = {
--     'nvim-neotest/nvim-nio',
--     'nvim-lua/plenary.nvim',
--     'antoinemadec/FixCursorHold.nvim',
--     'nvim-treesitter/nvim-treesitter',
--     'Issafalcon/neotest-dotnet',
--   },
--   config = function()
--     local neotest = require("neotest")
--     neotest.setup {
--       adapters = {
--         require('neotest-dotnet')({
--           dotnet_additional_args = {
--             "--verbosity detailed"
--           }
--         }),
--       },
--     }
--
--     require("which-key").add({ "<leader>t", group = "test" })
--     vim.keymap.set("n", "<leader>tt", neotest.run.run, { desc = "Run nearest test" })
--     vim.keymap.set("n", "<leader>td", neotest.run.run, { desc = "Debug nearest test" })
--   end
-- }
