local M = {}

-- Read the tags from the file.
local function get_tags()
  local dir = vim.fs.dirname(debug.getinfo(1, 'S').source:sub(2))
  local filename = vim.fs.joinpath(dir, 'tags.txt')
  local file = io.open(filename, 'r')

  if not file then
    print('Error: Could not open ' .. filename)
    return nil
  end

  local words = {}

  for line in file:lines() do
    line = vim.trim(line)
    if line ~= '' then table.insert(words, line) end
  end

  file:close()

  local pattern = '(' .. table.concat(words, '|') .. ')'
  return pattern
end

local function do_the_regex_bro(line, pattern)
  local new_line = vim.fn.substitute(line, pattern, 'test', 'g')
  vim.api.nvim_set_current_line(new_line)
end

-- Add quotation marks.
function M:add_quotations()
  local tags = get_tags()
  local pattern = [[\v]] .. [[(\w+\s+]] .. tags .. [[)|(]] .. tags .. [[\s+\w)]]

  local line = vim.api.nvim_get_current_line()

  if vim.fn.match(line, pattern) ~= -1 then
    do_the_regex_bro(line, pattern)
  else
    vim.api.nvim_set_current_line('"' .. line .. '"')
  end
end

return M
