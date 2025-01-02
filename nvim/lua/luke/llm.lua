local json = require("lib.lunajson")

local model = "codellama:latest" -- smaller, faster
--local model = "codellama:34b" -- bigger, maybe more accurate? seems slower

local state = {messages = {}, nextResponse = ""}

local current_prompt = "explain"
local prompts = {
  explain = "You are a helpful code assistant. You answer in concise but polite messages. When you give code examples you wrap them in markdown code blocks for the appropriate language.",
  code = "You are a skilled programmer who responds only with code. You always wrap code blocks in markdown code blocks for the appropriate language. You do not explain your work. You only reply in code that would run or compile if it was copy and pasted exactly as you provide it.",
}

local function reset()
  for i = 1, #state.messages do
    state.messages[i] = nil
  end
  table.insert(state.messages, {role = "system", content = prompts[current_prompt]})
end

local function doQuery(buffer)
  local lineCount = vim.api.nvim_buf_line_count(buffer)
  local lines = vim.api.nvim_buf_get_lines(buffer, 0, lineCount, false)
  local prompt = ""

  for _, line in ipairs(lines) do
    if line == "# User---" or line == "# System---" then
      prompt = ""
    else
      prompt = prompt .. line .. "\n"
    end
  end

  -- set the system prompt based on current_prompt
  state.messages[1].content = prompts[current_prompt]

  prompt = prompt:gsub("\n", "\\n"):gsub('"', '\\"')
  table.insert(state.messages, {role = "user", content = prompt})
  local curlArgs = {
    "-s",
    "-N",
    "-X",
    "POST",
    "http://localhost:11434/api/chat",
    "-d",
    string.format('{"model": "%s", "messages": %s}', model, json.encode(state.messages))
  }

  local stdin = vim.loop.new_pipe(false)
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)

  local handle
  handle, _ = vim.uv.spawn("curl", {
    args = curlArgs,
    stdio = {stdin, stdout, stderr}
  }, function(_, _)
    stdout:read_stop()
    stderr:read_stop()
    stdout:close()
    stderr:close()
    if handle then handle:close() end

    vim.schedule(function()
      vim.api.nvim_buf_set_lines(buffer, -1, -1, false, {
        "",
        "# User---",
        "",
        "",
      })
      vim.api.nvim_feedkeys("G$", "n", true)
    end)
    table.insert(state.messages, {role = "assistant", content = state.nextResponse})
    state.nextResponse = ""
  end)

  vim.api.nvim_buf_set_lines(buffer, -1, -1, false, {
    "",
    "# System---",
    "",
    "",
  })

  vim.uv.read_start(stdout, function(_, data)
    if data then
      vim.schedule(function()
        local object = json.decode(data)
        if object then
          if not object.done then
            local cleaned = object.message.content
            state.nextResponse = state.nextResponse .. cleaned
            local lastLine = vim.api.nvim_buf_get_lines(buffer, -2, -1, false)[1] or ""
            local newLastLine = vim.split(lastLine .. cleaned, "\n")
            vim.api.nvim_buf_set_lines(buffer, -2, -1, false, newLastLine)
          end

          vim.api.nvim_feedkeys("G$", "n", true)
        end
      end)
    end
  end)
end

-- TODO: figure out why this doesn't seem to actually work. Annoyingly, it's
-- hard to debug because the first time we check to see if we get a fast
-- response, that check warms it up
local function warmItUp()
  local curlArgs = {
    "-s",
    "-N",
    "-X",
    "POST",
    "http://localhost:11434/api/generate",
    "-d",
    string.format('{"model": "%s", "messages": []}', model)
  }
  vim.uv.spawn("curl", {args = curlArgs})
end

-- do a bunch of shenanigans to turn this window into an LLMy chat window kinda thing
-- for now, not going to worry about undoing it. Once done, just blow the buffer away
vim.api.nvim_create_user_command("LLM", function()
  vim.b.IS_LLM = true
  vim.bo.filetype = "markdown"
  vim.bo.buftype = "nofile"
  warmItUp()
  reset()
  local buffer = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buffer, 0, 0, false, {
    "# System---",
    "",
    "yes?",
    "",
    "# User---",
    "",
  })

  vim.api.nvim_buf_set_keymap(0, 'n', '<enter>', '', {
    noremap = true,
    silent = true,
    callback = function()
      doQuery(buffer)
    end
  })

  vim.api.nvim_buf_create_user_command(0, "System", function(opts)
    if #opts.args == 0 then
      print(current_prompt)
    elseif prompts[opts.args] then
      current_prompt = opts.args
    else
      print("that's not an option. Current options: explain, code")
    end
  end, {
    desc = "set the system prompt to one of the pre-built ones [explain|code]",
    nargs = '*',
  })

  vim.api.nvim_buf_create_user_command(0, "Clear", function()
    reset()
    vim.api.nvim_feedkeys("ggVGd", "n", true)
    vim.schedule(function()
      vim.api.nvim_buf_set_lines(buffer, 0, 0, false, {
        "# System---",
        "",
        "yes?",
        "",
        "# User---",
        "",
      })
    end)
  end, {
    desc = 'Clear/reset the conversation'
  })
  vim.api.nvim_buf_create_user_command(0, "Debug", function()
    local str = json.encode(state)
    local line = vim.api.nvim_win_get_cursor(0)[1] - 1
    vim.api.nvim_buf_set_lines(0, line, line, false, {str})
  end, {
    desc = 'Debug things'
  })
end, {
  desc = 'Set current buffer up as an LLM assistant window'
})
