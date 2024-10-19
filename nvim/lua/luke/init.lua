require("luke.settings")
if (os.getenv("CODE_LLM") == "ollama") then
  require("luke.llm")
end
require("luke.commands")
require("luke.keymaps")

function test()
  vim.api.nvim_put({"start"}, "c", true, true)
  vim.schedule(function()
    vim.api.nvim_put({"inside"}, "c", true, true)
  end)
  vim.api.nvim_put({"end"}, "c", true, true)
end

vim.api.nvim_create_user_command("Test", function(opts)
  test()
end, {})
