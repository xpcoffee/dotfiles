return {
    "nordtheme/vim",
    priority = 1000, -- load before other stuff
    config = function()
        vim.cmd("colorscheme nord")
    end
}
