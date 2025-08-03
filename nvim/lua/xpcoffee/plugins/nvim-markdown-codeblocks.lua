return {
  "xpcoffee/nvim-markdown-codeblocks",
  dev = false,
  dependencies = {},
  config = function()
    local codeblocks = require "nvim-markdown-codeblocks"
    codeblocks.setup()
  end
}
