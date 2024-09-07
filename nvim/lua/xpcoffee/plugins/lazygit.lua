return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  requires = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader><leader>g", "<cmd>LazyGit<cr>", desc = "LazyGit" }
  }
}
