local M = {}

--- Adds italics to line.
function M:italicize()
  local line = vim.api.nvim_get_current_line()
  vim.api.nvim_set_current_line('*' .. line .. '*')
end

return M
