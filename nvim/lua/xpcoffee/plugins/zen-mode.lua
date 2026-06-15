return {
  "folke/zen-mode.nvim",
  opts = {
    window = {
      width = 140, -- fixed column width; content centers in the remaining space
      options = {
        number = false,
        relativenumber = false,
      },
    },
    plugins = {
      tmux = { enabled = false }, -- leave tmux status bar alone; we only center within nvim
    },
  },
  keys = {
    { "<leader>z", "<cmd>ZenMode<CR>", desc = "Zen mode (center editor)" },
  },
}
