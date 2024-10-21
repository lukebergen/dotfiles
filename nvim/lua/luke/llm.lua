local json = require("lib.lunajson")

local query = function(prompt)
  --local curlArgs = string.format([[curl -s -N -X POST http://localhost:11434/api/generate -d '{ "model": "codellama", "prompt": "%s" }']], prompt)

  vim.cmd("vnew")
  prompt = string.gsub(prompt, "\n", "\\n")
  local curlArgs = {
    "-s",
    "-N",
    "-X",
    "POST",
    "http://localhost:11434/api/generate",
    "-d",
    string.format('{ "model": "codellama", "prompt": "%s" }', prompt)
  }

  local stdin = vim.loop.new_pipe(false)
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)

  local handle, pid = vim.uv.spawn("curl", {
    args = curlArgs,
    stdio = {stdin, stdout, stderr}
  }, function(code, signal)
    -- on exit
  end)

  vim.uv.read_start(stdout, function(err, data)
    if data then
      vim.schedule(function()
        local object = json.decode(data)
        if object.response:find("\n") then
          print("nil found")
        end
        local cleaned = object.response:gsub("\n", "\n")
        if cleaned then
          --vim.api.nvim_put({cleaned}, "c", true, true)
          vim.api.nvim_put(vim.split(cleaned, "\n"), "c", true, true)
          --vim.api.nvim_buf_set_lines(0, -1, -1, false, vim.split(cleaned, "\n"))
        end
      end)
    end
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
