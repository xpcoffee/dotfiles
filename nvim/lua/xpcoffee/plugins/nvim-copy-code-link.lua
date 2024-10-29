return {
  "xpcoffee/nvim-copy-code-link",
  dev = true,
  config = function()
    local plugin = require "nvim-copy-code-link"
    plugin.setup({})

    vim.keymap.set({ "n", "v" }, "<leader>yr", plugin.copy_url_to_unnamed,
      { desc = "Copy link to remote repo", remap = false })
  end
}
