return {
  'stevearc/oil.nvim',
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  config = function()
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      keymaps = {
        ["<CR>"] = "actions.select",
        ["<C-s>"] = "actions.preview",
        ["<C-o>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
        ["<C-c>"] = "actions.close",
        ["<C-r>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
      },
      view_options = {
        show_hidden = true
      },
      use_default_keymaps = false
    }
    local oil = require('oil')
    oil.setup(opts)
    vim.keymap.set("n", "-", oil.open_float, { desc = "Open parent directory" })
  end
}
