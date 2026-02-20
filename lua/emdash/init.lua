local M = {}

--- Adds the emdash when inputting three hyphens in a row.
--- AI generated.
local function add_emdash()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1], cursor[2]
  local line = vim.api.nvim_get_current_line()

  local before_cursor = line:sub(1, col)
  if before_cursor:sub(-2) == '--' then
    local after_cursor = line:sub(col + 1)
    local new_line = before_cursor:sub(1, -3) .. '—' .. after_cursor

    vim.api.nvim_set_current_line(new_line)
    vim.api.nvim_win_set_cursor(0, { row, col + 1 })
  else
    vim.api.nvim_put({ '-' }, 'c', false, true)
  end
end

function M.setup()
  vim.keymap.set('i', '-', function() add_emdash() end, { desc = 'Emdash shortcut', silent = true })
end

return M
