local function isRecording()
  local reg = vim.fn.reg_recording()
  if reg == "" then return "" end   -- not recording
  return "recording to " .. reg
end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    lualine.setup {
      options = {
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
      },
      sections = {
        lualine_y = {
          {
            isRecording,
            color = { bg = '#8EC07C', fg = '#0A0A0A', gui = 'none' },
          }
        }
      }
    }
  end
}
