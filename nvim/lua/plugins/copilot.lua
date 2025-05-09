-- some days you feel like a keymap
vim.keymap.set({'n', 'v'}, '<leader>xc', function()
  require("CopilotChat").toggle()
end, { desc = "CopilotChat - Quick chat" })

-- some days you feel like a command
vim.api.nvim_create_user_command("CC", function()
  vim.cmd('CopilotChat')
end, {range = true})

vim.api.nvim_create_user_command("CCExplain", function()
  vim.cmd('CopilotChatExplain')
end, {range = true})

vim.api.nvim_create_user_command("CCReview", function()
  vim.cmd('CopilotChatReview')
end, {range = true})

vim.api.nvim_create_user_command("CCReset", function()
  vim.cmd('CopilotChatReset')
end, {range = true})

vim.api.nvim_create_user_command("CCStop", function()
  vim.cmd('CopilotChatStop')
end, {range = true})

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
        model = 'gpt-4o-2024-11-20',

        -- doesn't actually work. TODO: figure out how to disable default system prompts so I can actually type the character "/" &co
        prompts = {Never = "!@#$%^&* I said never"},

        context = { "buffers:listed" },

        mappings = {
          show_info = {
            normal = 'gi'
          },
          show_context = {
            normal = 'gc'
          },
          show_help = {
            normal = 'gh'
          },
          reset = {
            normal = 'gx'
          }
        }

        -- Noooooope. Hate this
        --window = {
        --  layout = 'float',
        --  relative = 'cursor',
        --  width = 1,
        --  height = 0.4,
        --  row = 1
        --},
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
