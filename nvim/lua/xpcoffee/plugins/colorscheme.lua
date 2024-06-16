return {
    "nordtheme/vim", -- only on true color terminals
    --"chriskempson/base16-vim", -- only on true color terminals
    priority = 1000, -- load before other stuff
    config = function()
        vim.cmd("colorscheme nord")
        -- I currently have problems with seeing all the colors on Windowsterminal (especially the color-text on background)
        --vim.cmd("let base16colorspace=256")
    end
}
