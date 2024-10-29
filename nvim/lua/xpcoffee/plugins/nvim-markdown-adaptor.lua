return {
  "xpcoffee/nvim-markdown-adaptor",
  dependencies = {
    "nvim-lua/plenary.nvim", -- curl
    "vhyrro/luarocks.nvim",  -- pegasus http server for loopback oauth2
  },
  dev = false,
  config = function()
    local adaptor = require('nvim-markdown-adaptor')

    local test_fn = function()
      local document_id = "1MlkhxLgUxsol_zN6Irhy6jhcPSPZLKulBMV-YPSU6Bg"
      adaptor.sync_to_google_doc({ document_id = document_id })
    end

    -- adaptor.setup({
    --   data_file_path = "/home/rick/.nvim-markdown-adaptor.json",
    --   google_client_file_path = "/home/rick/.nvim-extension-client-secret.json",
    -- })
  end
}
