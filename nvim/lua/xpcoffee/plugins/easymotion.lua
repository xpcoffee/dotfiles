return {
    "easymotion/vim-easymotion",
    event = { "BufReadPre", "BufNewFile" },
    init = function()
        vim.keymap.set("n", "<space>", "<Plug>(easymotion-prefix)")
        vim.keymap.set("n", "f", "<Plug>(easymotion-f)")
        vim.keymap.set("n", "F", "<Plug>(easymotion-F)")
        vim.keymap.set("n", "t", "<Plug>(easymotion-t)")
        vim.keymap.set("n", "T", "<Plug>(easymotion-T)")
    end
}
