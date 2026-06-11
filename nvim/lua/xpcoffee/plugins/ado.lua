-- ADO work items. Implementation lives in the local repo
-- ~/code/personal/nvim-ado-workitems, loaded via dev=true (resolved through
-- lazy's dev.path), so it's never fetched online. The <leader>w which-key group
-- is declared in core/keymaps.lua alongside the others.
return {
  "xpcoffee/nvim-ado-workitems",
  dev = true,
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local ado = require("ado")
    ado.setup({})

    local keymap = vim.keymap
    keymap.set("n", "<leader>wm", ado.my_items, { desc = "My work items", remap = false })
    keymap.set("n", "<leader>ws", ado.search, { desc = "Search work items", remap = false })
    keymap.set("n", "<leader>wo", ado.open_prompt, { desc = "Open work item by ID", remap = false })
  end,
}
