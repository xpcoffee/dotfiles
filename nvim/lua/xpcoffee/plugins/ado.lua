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
    -- Organisation, projects and the write guard come from a gitignored
    -- machine-local module; without it the plugin needs $ADO_ORG and refuses writes.
    local ok, settings = pcall(require, "xpcoffee.local.ado")
    ado.setup(ok and settings or {})

    local keymap = vim.keymap
    keymap.set("n", "<leader>wm", ado.my_items, { desc = "My work items", remap = false })
    keymap.set("n", "<leader>ws", ado.search, { desc = "Search work items", remap = false })
    keymap.set("n", "<leader>wo", ado.open_prompt, { desc = "Open work item by ID", remap = false })
    keymap.set("n", "<leader>wa", ado.toggle_area_view, { desc = "Toggle list view", remap = false })
    keymap.set("n", "<leader>wA", ado.area_view, { desc = "Pick an area view", remap = false })
    keymap.set("n", "<leader>wi", ado.toggle_item_view, { desc = "Toggle item view", remap = false })
    keymap.set("n", "<leader>wI", ado.item_view, { desc = "Item view by ID", remap = false })
  end,
}
