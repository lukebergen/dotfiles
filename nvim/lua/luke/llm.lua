local json = require("lib.lunajson")

local function insert_text(text)
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local col = vim.api.nvim_win_get_cursor(0)[2]
  vim.api.nvim_buf_set_text(0, line - 1, col, line - 1, col, {text})
end

local query = function(prompt)
  local curl = string.format([[curl -s -X POST http://localhost:11434/api/generate -d '{ "model": "codellama", "prompt": "%s" }']], prompt)

  curl = string.gsub(curl, "\n", "\\n")
  local handle = io.popen(curl)

  --local win_id = vim.api.nvim_open_win(0, false, {
  --  relative = 'editor',
  --  width = 30,
  --  height = vim.o.lines,
  --  col = vim.o.columns / 2,
  --  row = 1,
  --  style = 'minimal',
  --  border = 'rounded',
  --})

  vim.api.nvim_command('vnew')
  local new_buffer_id = vim.api.nvim_get_current_buf()

  --vim.api.nvim_set_current_win(win_id)

  local i = 0
  for line in handle:lines() do
    local object = json.decode(line)
    --insert_text(object.resposne)
    vim.schedule(function()
      if (object.response and object.response ~= "") then
        vim.api.nvim_put({object.response}, "c", true, true)
      end
    end)
    -- Process each line of the response as it comes in
    --vim.api.nvim_buf_set_lines(0, -1, -1, false, {line})
    --local object = json.decode(line)
    --local lines = {}
    --for line in object.response:gmatch("[^\r\n]*") do
    --  print(line)
    --  table.insert(lines, line)
    --end
    --vim.api.nvim_buf_set_lines(0, -1, -1, false, lines)
  end
  
  handle:close()
end

-- maybe in future we can pull from other things like the full buffer or even other open buffers?
-- todo: make this less goofy. Look for examples and such
local promptFrom = function(input, context)
  return string.format([[
You are a helpful and skilled programmer who answers questions simply and concisely.
Here is some context:

---
%s
---

---
Given this context, please answer the following question:
---

%s
  ]], context, input)
end

local getContext = function(opts)
  local startLine = opts.line1
  local endLine = opts.line2
  local rangeContent = ""

  if opts.range == 0 then
    -- no range selected
  elseif opts.range == 1 then
    -- single line range
    local lines = vim.api.nvim_buf_get_lines(0, startLine - 1, endLine, false)
    rangeContent = table.concat(lines, "\n")
  else
    -- multi-line range
    local lines = vim.api.nvim_buf_get_lines(0, startLine - 1, endLine, false)
    local lines = vim.api.nvim_buf_get_lines(0, startLine - 1, endLine, false)
    rangeContent = table.concat(lines, "\n")
  end

  return rangeContent
end

vim.api.nvim_create_user_command("LLM", function(opts)
  local input = opts.args
  local context = getContext(opts)
  local prompt = promptFrom(input, context)
  query(prompt)
end, {
  nargs = '?',
  range = true,
  desc = 'Prompt an LLM'
})
