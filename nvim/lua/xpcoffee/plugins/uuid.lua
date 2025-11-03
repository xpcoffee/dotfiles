-- UUID utility - not a plugin, just custom functionality
local function generate_uuid4()
  local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  return string.gsub(template, '[xy]', function(c)
    local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
    return string.format('%x', v)
  end)
end

local function insert_uuid()
  local uuid = generate_uuid4()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { uuid })
  vim.api.nvim_win_set_cursor(0, { row, col + #uuid })
end

vim.api.nvim_create_user_command('UUID', insert_uuid, {})

-- Return empty table since this is not a plugin spec
return {}