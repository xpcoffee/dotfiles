return {
	"xpcoffee/nvim-markdown-notes",
	dev = true,
	dependencies = {},
	config = function()
		local notes = require("nvim-markdown-notes")
		notes.setup({
			notes_root_path = "~/code/personal/notes/",
			journal_dir_name = "journal",
		})

		-- notes
		vim.keymap.set("n", "<leader>nn", notes.create_note, { desc = "Create a new note", remap = false })

		-- journal
		vim.keymap.set("n", "<leader>njj", notes.open_daily_journal, { desc = "Open today's journal", remap = false })
		vim.keymap.set(
			"n",
			"<leader>njd",
			notes.open_journal,
			{ desc = "Open a journal note from the last 5 days", remap = false }
		)

		-- tags
		vim.keymap.set("n", "<leader>nta", notes.list_all_tags, { desc = "List all tags", remap = false })
		vim.keymap.set("n", "<leader>ntf", function()
			local tag = vim.fn.expand("<cword>")
			notes.view_files_with_tag(tag)
		end, { desc = "Show files with tag under cursor", remap = false })
	end,
}
