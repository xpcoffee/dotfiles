require("xpcoffee.core.options")
require("xpcoffee.core.keymaps")
require("xpcoffee.core.filetypes")

-- If you have xclip installed
vim.g.clipboard = {
  name = 'xclip',
  copy = {
    ['+'] = 'xclip -selection clipboard',
    ['*'] = 'xclip -selection primary',
  },
  paste = {
    ['+'] = 'xclip -selection clipboard -o',
    ['*'] = 'xclip -selection primary -o',
  },
}
