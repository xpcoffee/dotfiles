return {
  "xpcoffee/nvim-markdown-tools",
  dev = false,
  dependencies = {
    "nvim-telescope/telescope.nvim"
  },
  config = function()
    local nvim_markdown_tools = require "nvim-markdown-tools"
    nvim_markdown_tools.setup({
      notes_root_path = "~/code/notes/",
      journal_dir_name = "journal"
    })

    vim.keymap.set("n", "<leader>nd", nvim_markdown_tools.open_daily_journal,
      { desc = "Open today's journal", remap = false })
    vim.keymap.set("n", "<leader>nj", nvim_markdown_tools.open_journal,
      { desc = "Open a journal note from the last 5 days", remap = false })
    vim.keymap.set("n", "<leader>nta", nvim_markdown_tools.list_all_tags, { desc = "List all tags", remap = false })
    vim.keymap.set("n", "<leader>ntt", nvim_markdown_tools.view_files_with_tag,
      { desc = "View files for tag under cursor", remap = false })
    vim.keymap.set("n", "<leader>nb", nvim_markdown_tools.list_backlinks, { desc = "List backlinks", remap = false })

    -- temporary keybinds for quick dev
    local dev_plugin = "nvim-markdown-tools"
    vim.keymap.set("n", "<leader><leader>r", ':Lazy reload ' .. dev_plugin .. '<cr>',
      { desc = "Reload " .. dev_plugin })
  end
}
