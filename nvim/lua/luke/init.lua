require("luke.settings")
if (os.getenv("CODE_LLM") == "local") then
  require("luke.llm")
end
require("luke.commands")
require("luke.keymaps")
