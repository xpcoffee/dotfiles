return {
  "williamboman/mason.nvim",
  dependencies = {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    print("mason config")
    local mason = require("mason")
    local mason_tool_installer = require("mason-tool-installer")

    mason.setup({})

    mason_tool_installer.setup({
      ensure_installed = {
        "prettier",
        "js-debug-adapter",
      },
    })
  end,
}
