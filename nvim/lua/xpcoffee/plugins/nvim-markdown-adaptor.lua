return {
  "xpcoffee/nvim-markdown-adaptor",
  dev = true,
  config = function()
    local adaptor = require('nvim-markdown-adaptor')
    vim.keymap.set("n", "<leader><leader>p", adaptor.convertFile)
    vim.keymap.set("n", "<leader><leader>r", ':Lazy reload nvim-markdown-adaptor<cr>')
  end
}
