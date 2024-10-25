return {
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      defaults = {
        file_ignore_patterns = { "node_modules" }
      },
    }

    --config = function()
    --  require('telescope').load_extension('live_grep_args')
    --  vim.keymap.set('n', '<leader>fg', require("telescope").extensions.live_grep_args.live_grep_args, { noremap = true })
    --end,
  }
}
