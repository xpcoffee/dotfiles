return {
  "xpcoffee/nvim-markdown-codeblocks",
  dev = true,
  dependencies = {},
  config = function()
    local codeblocks = require "nvim-markdown-codeblocks"
    codeblocks.setup()
  end
}
