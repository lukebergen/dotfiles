return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    lazy = false,
    priority = 100, -- lower because it's not important that it load faster than anything else. In fact, we can wait for a while for it to load most of the time
    enabled = function()
      return os.getenv("COPILOT_AVAILABLE") == "true"
    end,
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = false,
        hide_during_completion = true,
        debounce = 75,
        keymap = {
          accept = "<C-k>",
          accept_word = false,
          accept_line = false,
          next = "<C-l>",
          prev = "<C-h>",
          dismiss = "<C-j>", --"<C-]>",
        },
      },
      panel = { enabled = false },
      copilot_node_command = "node_insecure",
      --filetypes = {
      --  markdown = true,
      --  help = true,
      --},
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    lazy = false,
    priority = 100, -- lower because it's not important that it load faster than anything else. In fact, we can wait for a while for it to load most of the time
    build = "make tiktoken", -- Only on MacOS or Linux
    cmd = "CopilotChat",
    opts = {
      debug = false,
      -- clear_chat_on_new_prompt = true,
    },
    enabled = function()
      return os.getenv("COPILOT_AVAILABLE") == "true"
    end,
    -- see `:help CopilotChat` for more info
    -- See Commands section for default commands if you want to lazy load on them
  },
  -- others to consider:
  --   copilot-cmp (requires nvim-cmp)
  --   copilot-chat
  --   edgy?? (I guess it's a window layout editor/creator/manager and copilot-chat can work with it?)
}
