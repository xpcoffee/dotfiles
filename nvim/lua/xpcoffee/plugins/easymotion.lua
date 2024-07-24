return {
    "easymotion/vim-easymotion",
    event = { "BufReadPre", "BufNewFile" },
    init = function()
        vim.keymap.set("n", "<space><space>f", "<Plug>(easymotion-prefix)")
        vim.keymap.set({ "n", "v" }, "f", "<Plug>(easymotion-prefix)s")
    end,
}
