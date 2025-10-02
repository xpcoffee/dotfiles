
if vim.g.vscode then
    require("xpcoffee.vscode")
else
    require("xpcoffee.core")
    require("xpcoffee.lazy")
end