return {
    "nordtheme/vim", -- only on true color terminals
    --"chriskempson/base16-vim", -- only on true color terminals
    priority = 1000, -- load before other stuff
    config = function()
        -- basic appearance
        vim.opt.termguicolors = true
        vim.cmd("colorscheme nord")
    end
}
