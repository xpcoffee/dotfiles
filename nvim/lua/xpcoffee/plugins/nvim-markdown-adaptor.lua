return {
  "xpcoffee/nvim-markdown-adaptor",
  dependencies = {
    "nvim-lua/plenary.nvim", -- curl
    "vhyrro/luarocks.nvim",  -- pegasus http server for loopback oauth2
  },
  dev = false,
  config = function()
    local adaptor = require('nvim-markdown-adaptor')

    -- adaptor.setup({
    --   data_file_path = vim.fn.expand("~/.nvim-markdown-adaptor.json"),
    --   google_client_file_path = vim.fn.expand("~/.nvim-extension-client-secret.json"),
    -- })
  end
}
