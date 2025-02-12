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
        enabled = false,
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
    branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    lazy = false,
    priority = 100, -- lower because it's not important that it load faster than anything else. In fact, we can wait for a while for it to load most of the time
    build = "make tiktoken", -- Only on MacOS or Linux
    cmd = "CopilotChat",
    enabled = function()
      return os.getenv("COPILOT_AVAILABLE") == "true"
    end,
    config = function()
      require("CopilotChat").setup({
        debug = false,

        -- doesn't actually work. TODO: figure out how to disable default system prompts so I can actually type the character "/" &co
        prompts = {Never = "!@#$%^&* I said never"},
      })
      -- see https://github.com/CopilotC-Nvim/CopilotChat.nvim/issues/691
      -- however, I think we're actually fine to just set this globally. Set over in nvim-cmp config
--      vim.api.nvim_create_autocmd('BufEnter', {
--        pattern = "copilot-*",
--        callback = function()
--          vim.opt.completeopt = vim.opt.completeopt + "noinsert" + "noselect"
--        end
--      })
--      vim.api.nvim_create_autocmd('BufLeave', {
--        pattern = "copilot-*",
--        callback = function()
--          vim.opt.completeopt = vim.opt.completeopt - "noinsert" - "noselect"
--        end
--      })
    end
    -- see `:help CopilotChat` for more info
    -- See Commands section for default commands if you want to lazy load on them
  },
  -- others to consider:
  --   copilot-cmp (requires nvim-cmp)
  --   copilot-chat
  --   edgy?? (I guess it's a window layout editor/creator/manager and copilot-chat can work with it?)
}
