local M = {}

--- Read the tags from the file.
--- @return string|nil
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

--- Applies regex patterns to the given line.
--- @param line string
--- @param tags string
--- @return string
local function do_the_regex_bro(line, tags)
  -- "You should know by now," she said, "that regex is dog water."
  local pattern_one = [[\v(.{-}[,?!])\s+(\w+\s+]] .. tags .. [[[\.,]|]] .. tags .. [[\s+\w+[\.,])\s+(.*)]]
  -- He sighed and said, "I know, Jane. I know."
  local pattern_two = [[\v(.{-}(]] .. tags .. [[),)\s+(.*)]]
  -- "Then why do you insist on using it?" she asked.
  local pattern_three = [[\v(.{-}[,?!])\s+(\w+\s+]] .. tags .. [[|]] .. tags .. [[\s+\w+)]]
  -- "I don't."
  local new_line = '"' .. line .. '"'

  if vim.fn.match(line, pattern_one) ~= -1 then
    new_line = vim.fn.substitute(line, pattern_one, [["\1" \2 "\5"]], 'g')
  elseif vim.fn.match(line, pattern_two) ~= -1 then
    new_line = vim.fn.substitute(line, pattern_two, [[\1 "\4"]], 'g')
  elseif vim.fn.match(line, pattern_three) ~= -1 then
    new_line = vim.fn.substitute(line, pattern_three, [["\1" \2]], 'g')
  end

  return new_line
end

--- Add quotation marks to line.
function M:add_quotations()
  local tags = get_tags()
  if tags == nil then return end -- Not ideal, but w/e.

  local pattern = [[\v]] .. [[(\w+\s+]] .. tags .. [[)|(]] .. tags .. [[\s+\w)]]
  local line = vim.api.nvim_get_current_line()

  if vim.fn.match(line, pattern) ~= -1 then
    local new_line = do_the_regex_bro(line, tags)
    vim.api.nvim_set_current_line(new_line)
  else
    vim.api.nvim_set_current_line('"' .. line .. '"')
  end
end

return M
