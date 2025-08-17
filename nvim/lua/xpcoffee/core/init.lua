require("xpcoffee.core.options")
require("xpcoffee.core.keymaps")
require("xpcoffee.core.filetypes")

-- If you have xclip installed
if vim.fn.has('wsl') == 1 or vim.fn.has('win32') == 1 then
  vim.g.clipboard = {
    name = 'clip.exe',
    copy = {
      ['+'] = 'clip.exe',
      ['*'] = 'clip.exe',
    },
    paste = {
      ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
  }
end
