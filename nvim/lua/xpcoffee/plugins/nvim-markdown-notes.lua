return {
  "xpcoffee/nvim-markdown-notes",
  dev = true,
  dependencies = {},
  config = function()
    local notes = require("nvim-markdown-notes")
    notes.setup({
      notes_root_path = "~/code/personal/notes/",
      highlights = {
        ["@markup.wikilink"] = { link = "Type" },
        ["@markup.mention"] = { link = "@function.builtin" },
        ["@markup.tag"] = { link = "Number" },
      },
      memgraph = {
        enabled = vim.env.NOTES_ROOT ~= nil and vim.fn.getcwd():find(vim.env.NOTES_ROOT, 1, true) ~= nil,
      },
    })

    local graph = notes.graph
    local keymap = vim.keymap

    -- notes
    keymap.set("n", "<leader>nn", notes.create_note, { desc = "Create a new note", remap = false })

    -- journal
    keymap.set("n", "<leader>nj", notes.open_daily_journal, { desc = "Open today's journal", remap = false })
    keymap.set("n", "<leader>nd", notes.open_journal, { desc = "Open journal for a day (last 5 days)", remap = false })

    -- graph navigation
    keymap.set("n", "<leader>nt", function() graph.browse_tags() end, { desc = "Browse tags", remap = false })
    keymap.set("n", "<leader>np", function() graph.browse_people() end, { desc = "Browse people", remap = false })
    keymap.set("n", "<leader>nb", function() graph.show_backlinks() end, { desc = "Show backlinks", remap = false })
    keymap.set("n", "<leader>nr", function() graph.show_related() end, { desc = "Show related notes", remap = false })
    keymap.set("n", "<leader>nc", function() graph.get_commands().show_context() end, { desc = "Show note context", remap = false })

    -- graph admin
    keymap.set("n", "<leader>nmi", function() graph.reindex() end, { desc = "Reindex graph", remap = false })
    keymap.set("n", "<leader>nms", function() vim.cmd("MarkdownNotesGraphStatus") end, { desc = "Graph status", remap = false })
  end
}
