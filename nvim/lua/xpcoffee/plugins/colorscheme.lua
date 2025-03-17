return {
  "EdenEast/nightfox.nvim", -- only on true color terminals
  priority = 1000,          -- load before other stuff
  config = function()
    require('nightfox').setup({})
    vim.cmd("colorscheme nordfox")
  end
}
