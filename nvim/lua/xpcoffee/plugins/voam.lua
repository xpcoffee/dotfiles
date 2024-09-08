return {
  "xpcoffee/voam",
  dev = true,
  config = function()
    local voam = require "voam"
    voam.setup({
      notes_root_path = "~/code/notes/",
      journal_dir_name = "journal"
    })

    vim.keymap.set("n", "<C-]>", voam.trigger_backlink, { desc = "Trigger internal link at cursor", remap = false })
    vim.keymap.set("n", "<leader>nd", voam.open_daily_note, { desc = "Open daily note", remap = false })

    -- temporary keybinds for quick dev
    local dev_plugin = "voam"
    local test_fn = voam.trigger_backlink
    vim.keymap.set("n", "<leader><leader>p", test_fn, { desc = "Run " .. dev_plugin })
    vim.keymap.set("n", "<leader><leader>r", ':Lazy reload ' .. dev_plugin .. '<cr>',
      { desc = "Reload " .. dev_plugin })
  end
}
