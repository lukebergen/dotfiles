return {
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    -- why does this not work? It's supposed to
    --opts = {
    --  defaults = {
    --    file_ignore_patterns = { "node_modules" },
    --    winblend = 20,
    --  },
    --},

    config = function()
      require("telescope").setup({
        defaults = {
          winblend = 20, -- let's see if this just ends up annoying us
          file_ignore_patterns = { "node_modules" },
        },
      })

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { noremap = true, desc = "[f]ind [f]ile"})
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { noremap = true, desc = "[f]ind files [g]repping through their content"})
      vim.keymap.set('n', '<leader>ft', builtin.treesitter, { noremap = true, desc = "[f]ind from [t]reesitter" })
      vim.keymap.set('n', '<leader>fc', builtin.git_commits, { noremap = true, desc = "[f]ind from [c]ommits"})
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { noremap = true, desc = "[f]ind open [b]uffer"})
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { noremap = true, desc = "[f]ind in [h]elp"})
      vim.keymap.set('n', '<leader>fi', builtin.highlights, { noremap = true, desc = "[f]ind in [h]elp"})
      vim.keymap.set('n', '<leader>fr', builtin.resume, { noremap = true, desc = "[r]esume previous search"})
    end
  }
}
