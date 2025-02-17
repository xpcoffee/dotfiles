return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        local which_key = require("which-key")
        which_key.setup({})
    end
}