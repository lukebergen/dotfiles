local json = require("lib.lunajson")

-- TODO: rethink about all of this given how we tend to use copilot


local query = function(prompt, opts) --newWindow, skipBackticks)
  --local curlArgs = string.format([[curl -s -N -X POST http://localhost:11434/api/generate -d '{ "model": "codellama", "prompt": "%s" }']], prompt)

  local newWindow = opts.newWindow ~= false
  local skipBackticks = opts.skipBackticks == true

  local outputBuffer = vim.api.nvim_get_current_buf()

  if newWindow then
    local startingWindow = vim.api.nvim_get_current_win()
    vim.cmd("vnew")
    outputBuffer = vim.api.nvim_get_current_buf()
    vim.api.nvim_set_current_win(startingWindow)
  end

  prompt = string.gsub(prompt, "\n", "\\n"):gsub('"', "\\\"")
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

  vim.uv.read_start(stdout, function(_, data)
    if data then
      vim.schedule(function()
        local object = json.decode(data)
        local cleaned = object.response
        if cleaned and (not skipBackticks or not cleaned:find("^```")) then
          local lastLine = vim.api.nvim_buf_get_lines(outputBuffer, -2, -1, false)[1] or ""
          local newLastLine = vim.split(lastLine .. cleaned, "\n")
          vim.api.nvim_buf_set_lines(outputBuffer, -2, -1, false, newLastLine)
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

%s

---

Given this context, please answer the following question:

%s
  ]], context, input)
end

local codeOnlyPrompt = function(input, context)
  return string.format([[
You are a helpful and skilled programmer. You only respond with code. You do not include backticks to demarcate chunks of code. The code you provide is syntactically correct and complete on its own unless it refers to something in context. Do not include backticks.
Here is some context:

---
%s
---

Given this context, write code for the following: %s]], context, input)
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
  query(prompt, {newWindow = true})
end, {
  nargs = '?',
  range = true,
  desc = 'Prompt an LLM'
})

vim.api.nvim_create_user_command("C", function(opts)
  local input = opts.args
  local context = getContext(opts)
  local prompt = codeOnlyPrompt(input, context)
  query(prompt, {newWindow = true, skipBackticks = true})
end, {
  nargs = '?',
  range = true,
  desc = 'Prompt an LLM'
})

--vim.api.nvim_create_user_command("C", function(opts)
--  print("still working on that one")
--  --local input = opts.args
--  --local context = ""
--  --local prompt = promptFrom(input, context)
--  --query(prompt, false)
--end, {
--  nargs = '?',
--  desc = 'Write some code in the current buffer'
--})
