return {
  "xpcoffee/nvim-markdown-adaptor",
  dependencies = {
    "nvim-lua/plenary.nvim", -- curl
    "vhyrro/luarocks.nvim",  -- pegasus http server for loopback oauth2
  },
  dev = true,
  config = function()
    local adaptor = require('nvim-markdown-adaptor')
    local test_fn = function()
      local document_id = "1MlkhxLgUxsol_zN6Irhy6jhcPSPZLKulBMV-YPSU6Bg"
      adaptor.sync_to_google_doc({ document_id = document_id })
    end
    vim.keymap.set("n", "<leader><leader>p", test_fn, { desc = "Test nvim-markdown-adaptor" })
    vim.keymap.set("n", "<leader><leader>r", ':Lazy reload nvim-markdown-adaptor<cr>',
      { desc = "Reload nvim-markdown-adaptor" })
  end
}
