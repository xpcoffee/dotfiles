vim.g.mapleader = ","

local keymap = vim.keymap -- for conciseness

keymap.set("n", "<leader>v", ":e ~/.config/nvim/init.lua<CR>", { desc = "Open root init.lua" })

keymap.set("n", "<leader>bn", "<cmd>bn<CR>", { desc = "Next buffer" })
keymap.set("n", "<leader>bp", "<cmd>bp<CR>", { desc = "Previous buffer" })

-- remap the macro key
keymap.set("n", "<leader>q", "q", { desc = "Macro key" })
keymap.set("n", "q", "<Nop>", {})

-- remap help
-- which-key causes a delay for all : commands if you remap one of them...
-- disabling for now
-- keymap.set("n", ":help", ":vert help", { desc = "which_key_ignore" })

-- tweak search highlighting behaviour
keymap.set("n", "*", ":set nohlsearch<CR>*")
keymap.set("n", "#", ":set nohlsearch<CR>#")
keymap.set("n", "/", ":set hlsearch<CR>/")
keymap.set("n", "?", ":set hlsearch<CR>/")

-- copy file path
keymap.set("n", "<leader>yp", function() vim.fn.setreg("+", vim.fn.expand("%:p")) end, { desc = "Copy absolute file path" })

-- messages
keymap.set("n", "<leader>ll", ":messages<CR>", { desc = "messages" })
keymap.set("n", "<leader>lc", ":messages clear<CR>", { desc = "clear messages" })

-- quickfix list delete keymap
function Remove_qf_item()
  local curqfidx = vim.fn.line('.')
  local qfall = vim.fn.getqflist()

  -- Return if there are no items to remove
  if #qfall == 0 then return end

  -- Remove the item from the quickfix list
  table.remove(qfall, curqfidx)
  vim.fn.setqflist(qfall, 'r')

  -- Reopen quickfix window to refresh the list
  vim.cmd('copen')

  -- If not at the end of the list, stay at the same index, otherwise, go one up.
  local new_idx = curqfidx < #qfall and curqfidx or math.max(curqfidx - 1, 1)

  -- Set the cursor position directly in the quickfix window
  local winid = vim.fn.win_getid() -- Get the window ID of the quickfix window
  vim.api.nvim_win_set_cursor(winid, { new_idx, 0 })
end

vim.cmd("command! RemoveQFItem lua Remove_qf_item()")
vim.api.nvim_command("autocmd FileType qf nnoremap <buffer> dd :RemoveQFItem<cr>")

-- which-key group names
-- deferred so which-key is loaded first
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyLoad",
  callback = function(event)
    if event.data ~= "which-key.nvim" then return end
    local wk = require("which-key")
    wk.add({
      { "<leader>b", group = "buffers", icon = "󰈔" },
      { "<leader>c", group = "code", icon = "󰏗" },
      { "<leader>l", group = "logs", icon = "󰐅" },
      { "<leader>n", group = "notes", icon = "󰂽" },
      { "<leader>y", group = "yank", icon = "󰆏" },
      { "<leader><leader>", group = "core", icon = "󰛡" },
    })
  end,
})

M = {}
return M
