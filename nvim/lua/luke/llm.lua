local json = require("lib.lunajson")

local function insert_text(text)
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local col = vim.api.nvim_win_get_cursor(0)[2]
  vim.api.nvim_buf_set_text(0, line - 1, col, line - 1, col, {text})
  vim.api.nvim_win_set_cursor(0, {line, col + #text})
end

local query = function(prompt)
  local curl = string.format([[curl -s -N -X POST http://localhost:11434/api/generate -d '{ "model": "codellama", "prompt": "%s" }']], prompt)
  curl = string.gsub(curl, "\n", "\\n")

  --print("curl: " .. curl)

  local handle = io.popen(curl)

  vim.api.nvim_command('vnew')

  --local processLine = function()
  --  local line = handle:read("*line")
  --  print("line: " .. line)
  --  if line then
  --    local object = json.decode(line)
  --    --vim.schedule(function()
  --      vim.api.nvim_put({object.response}, "c", true, true)
  --    --end)
  --    -- Schedule the next read with a small delay
  --    vim.defer_fn(processLine, 1)
  --  else
  --    handle:close()
  --  end
  --end
  --processLine()


  vim.schedule(function()
    for line in handle:lines() do
      local object = json.decode(line)
      if (object.response and object.response ~= "") then
        vim.api.nvim_put({object.response}, "c", true, true)
      end
    end
    handle:close()
  end)
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
