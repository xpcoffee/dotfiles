return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring", --tsx/jsx
  },
  config = function()
    local comment = require("Comment")
    local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

    comment.setup({
      pre_hook = ts_context_commentstring.create_pre_hook(),
    })


    local api = require("Comment.api");
    local function log_and_do()
      print("hahaha")
      api.toggle.linewise.current()
    end

    vim.keymap.set({ "n" }, "<leader>t", log_and_do, {
      noremap = true, silent = true
    })

    -- get region comments to work
    -- https://github.com/numToStr/Comment.nvim/blob/master/lua/Comment/api.lua#L94
    local esc = vim.api.nvim_replace_termcodes(
      '<ESC>', true, false, true
    )
    local toggleSelection = function()
      vim.api.nvim_feedkeys(esc, 'nx', false)
      api.toggle.linewise(vim.fn.visualmode())
    end
    vim.keymap.set({ "v" }, "<leader>t", toggleSelection, {})
  end,
}
