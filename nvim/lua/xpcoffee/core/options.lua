local opt = vim.opt

opt.number = true
vim.wo.relativenumber = true
opt.cursorline = true
vim.opt.signcolumn = "yes"

-- indendations
opt.tabstop = 2
opt.shiftwidth = 2
opt.autoindent = true
vim.cmd("set expandtab")

-- searching
opt.ignorecase = true
opt.smartcase = true -- don't ignore case if you have mixed case in search

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
local function is_whitespace_only(lines)
  for _, line in ipairs(lines) do
    if line:match("%S") then
      return false
    end
  end
  return true
end

if vim.fn.system("uname -r"):lower():find("microsoft") then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = function(lines, _)
        if is_whitespace_only(lines) then return end
        vim.fn.system("xclip -selection clipboard", lines)
      end,
      ["*"] = function(lines, _)
        if is_whitespace_only(lines) then return end
        vim.fn.system("xclip -selection clipboard", lines)
      end,
    },
    paste = {
      ["+"] = function()
        local content = vim.fn.system("xclip -selection clipboard -o")
        local lines = vim.split(content, "\n", { plain = true })
        -- If content ends with a newline, it was a linewise yank
        if content:sub(-1) == "\n" then
          table.remove(lines) -- remove trailing empty element
          return { lines, "V" }
        end
        return { lines, "v" }
      end,
      ["*"] = function()
        local content = vim.fn.system("xclip -selection clipboard -o")
        local lines = vim.split(content, "\n", { plain = true })
        if content:sub(-1) == "\n" then
          table.remove(lines)
          return { lines, "V" }
        end
        return { lines, "v" }
      end,
    },
    cache_enabled = 1,
  }
end
opt.clipboard:append("unnamedplus") -- system clipboard as default register

-- don't attempt to load perl things
vim.cmd("let g:loaded_perl_provider = 0")

-- remap escape in terminals
vim.cmd("tnoremap <Esc> <C-\\><C-n>")


-- remove windows line endings
if vim.g.remove_windows_line_endings == nil then
  vim.g.remove_windows_line_endings = true
end

vim.api.nvim_create_autocmd({ "BufRead" }, {
  pattern = "*",
  callback = function()
    if vim.g.remove_windows_line_endings then
      vim.cmd("set fileformat=unix")
    end
  end,
})
