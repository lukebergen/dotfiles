return {
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
    config = function(_, opts)
      local gitsigns = require("gitsigns")
      gitsigns.setup(opts)

      -- surround doesn't come with gitsigns support so just simulate it ourselves
      vim.keymap.set('n', '[g', function()
        gitsigns.nav_hunk('prev')
      end)
      vim.keymap.set('n', ']g', function()
        gitsigns.nav_hunk('next')
      end)
    end
  },
}
