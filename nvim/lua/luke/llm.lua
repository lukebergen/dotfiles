-- TODO: try doing this in a more structured way. Maybe chat with messages being more
-- explicit about what's from the user and what's from the assistant?
local json = require("lib.lunajson")

local system = "You are a helpful code assistant. Ignore any lines that looks like '--user--------' or '--system-----'. Do not include lines like '--system-----' in your outputs."
local function doQuery(buffer)
  --local curlArgs = string.format([[curl -s -N -X POST http://localhost:11434/api/generate -d '{ "model": "codellama", "prompt": "%s" }']], prompt)

  local lineCount = vim.api.nvim_buf_line_count(buffer)
  local lines = vim.api.nvim_buf_get_lines(buffer, 0, lineCount, false)
  local prompt = ""
  for _, line in ipairs(lines) do prompt = prompt .. line .. "\n" end
  prompt = prompt:gsub("\n", "\\n"):gsub('"', '\\"')
  local curlArgs = {
    "-s",
    "-N",
    "-X",
    "POST",
    "http://localhost:11434/api/generate",
    "-d",
    string.format('{ "model": "codellama", "system": "%s", "prompt": "%s" }', system, prompt)
  }

  -- place to debug. Print the curlArgs

  local stdin = vim.loop.new_pipe(false)
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)

  local handle
  handle, _ = vim.uv.spawn("curl", {
    args = curlArgs,
    stdio = {stdin, stdout, stderr}
  }, function(code, signal)
    stdout:read_stop()
    stderr:read_stop()
    stdout:close()
    stderr:close()
    if handle then handle:close() end

    vim.schedule(function()
      vim.api.nvim_buf_set_lines(buffer, -1, -1, false, {
        "",
        "--user-------",
        "",
      })
    end)
    -- we're done getting things back
  end)

  vim.api.nvim_buf_set_lines(buffer, -1, -1, false, {
    "",
    "--system-----",
    "",
  })

  vim.uv.read_start(stdout, function(_, data)
    if data then
      vim.schedule(function()
        local object = json.decode(data)
        if object then
          local cleaned = object.response
          local lastLine = vim.api.nvim_buf_get_lines(buffer, -2, -1, false)[1] or ""
          local newLastLine = vim.split(lastLine .. cleaned, "\n")
          vim.api.nvim_buf_set_lines(buffer, -2, -1, false, newLastLine)
        end
      end)
    end
  end)
end

-- do a bunch of shenanigans to turn this window into an LLMy chat window kinda thing
-- for now, not going to worry about undoing it. Once done, just blow the buffer away
vim.api.nvim_create_user_command("LLM", function()
  vim.b.IS_LLM = true
  vim.bo.filetype = "markdown"
  local buffer = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buffer, 0, 0, false, {
    "system: yes?",
    "",
    "--user--------",
    "",
  })

  vim.api.nvim_buf_set_keymap(0, 'n', '<enter>', '', {
    noremap = true,
    silent = true,
    callback = function()
      doQuery(buffer)
    end
  })
end, {
  desc = 'Set current buffer up as an LLM assistant window'
})
