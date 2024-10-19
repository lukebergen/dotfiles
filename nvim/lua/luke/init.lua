require("luke.settings")
if (os.getenv("CODE_LLM") == "ollama") then
  require("luke.llm")
end
require("luke.commands")
require("luke.keymaps")

local curl = require('plenary.curl')
local json = require("lib.lunajson")

local function process_chunk(chunk)
  -- Process each chunk of data here
  -- For example, append it to a buffer
  vim.schedule(function()
    local lines = vim.split(chunk, "\n")
    vim.api.nvim_buf_set_lines(0, -1, -1, false, lines)
  end)
end

local function streamResponse()
  curl.post({
    url = "http://localhost:11434/api/generate",
    stream = true,
    body = '{"model": "codellama", "prompt": "write a fib function in lua"}',
    callback = function(data, callback)
      if data then
        process_chunk(data)
      end
      callback()
    end,
  })
end

vim.api.nvim_create_user_command('TestNewThing', streamResponse, {})
