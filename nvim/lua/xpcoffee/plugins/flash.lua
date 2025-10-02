return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    label = {
      rainbow = {
        enabled = true,  -- Enable rainbow mode which overlays labels
      },
    },
    modes = {
      char = {
        enabled = false,  -- Disable the f/F/t/T character search
      },
    },
  },
  keys = {
    { "f", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash", remap = false},
    { "F", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter", remap = false },
    { "R", mode = { "n", "x", "o" }, function() require("flash").treesitter_search() end, desc = "Flash Treesitter search", remap = false },
  },
}