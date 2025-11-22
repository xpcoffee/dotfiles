return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer", -- completion source of current buffer
		"hrsh7th/cmp-path",
		"onsails/lspkind.nvim", -- vscode-like pictograms in completion
		"xpcoffee/nvim-markdown-notes",
	},
	config = function()
		local cmp = require("cmp")
		local lspkind = require("lspkind")
		local markdown_notes = require("nvim-markdown-notes")

		markdown_notes.register_wikilink_cmp_source(cmp, "wiki_links")

		cmp.setup({
			completion = {
				completeopt = "menu,menuone,preview,noselect",
			},
			mapping = cmp.mapping.preset.insert({
				["<S-Tab>"] = cmp.mapping.select_prev_item(), -- previous suggestion
				["<Tab>"] = cmp.mapping.select_next_item(), -- next suggestion
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
				["<CR>"] = cmp.mapping.confirm({ select = false }),
			}),
			sources = cmp.config.sources({
				--first group has priority
				{ name = "wiki_links" },
			}, {
				-- second group only if first group doesn't match
				--ordering matters for priority
				{ name = "nvim_lsp" },
				{ name = "buffer" },
				{ name = "path" },
			}),
			formatting = {
				format = lspkind.cmp_format({
					maxwidth = 50,
					ellipsis_char = "...",
				}),
			},
		})
	end,
}
