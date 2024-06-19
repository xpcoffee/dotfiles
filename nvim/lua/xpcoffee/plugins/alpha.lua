return {
    "goolord/alpha-nvim", -- greeter
    event = "VimEnter",
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        dashboard.section.header.val = {
            "                      /%&@&%,                     ",
            "              %@@@@@@@@@@*@@@@@@@@@@(             ",
            "          @@@@@@@@@  /@@*  @@@  @@@@@@@@*         ",
            "       %@@@@@@.  &.              #.  @@@@@@       ",
            "     @@@@%  &@        .     *        #@  ,@@@.    ",
            "   *@@@@@@@           .,   ,*.  .       @@@@@@@   ",
            "  @@@@#              **  .**,  ,*           .@@@  ",
            " %@@@@@@            *.  ***  .*,           @@@@@@ ",
            " @@@.               *   *    *                 @@@",
            "%@@@@@&                 *    .              /@@@@@",
            "@@@                                             @@",
            "(@@@@@&          #@@@@@@@@@@@@@@@@/         /@@@@@",
            " @@@.         @& .@@@@@@@@@@@@@@@@             @@%",
            " /@@@@@@      @   @@@@@@@@@@@@@@@&         @@@@@@ ",
            "  #@@@#        @%  @@@@@@@@@@@@@/           .@@@  ",
            "    @@@@@@@          /@@@@@@@@*         @@@@@@&   ",
            "     *@@@%  &@     %@@@@@@@@@@@&.    %@  ,@@@     ",
            "       .@@@@@@.  @,              #.  @@@@@&       ",
            "           @@@@@@@@  /@@*  @@@  @@@@@@@@          ",
            "              .@@@@@@@@@@/@@@@@@@@@/              ",
        }


        -- set menu
        dashboard.section.buttons.val = {
            dashboard.button(", ee", "Explorer > Toggle explorer", "<cmd>NvimTreeToggle<CR>"),
        }

        -- send config to alpha
        alpha.setup(dashboard.opts)

        -- disable folding on buffer
        vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
    end,
}
