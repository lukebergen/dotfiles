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
          preview = {
            mime_hook = function(filepath, bufnr, opts)
              local is_image = function(filepath)
                local image_extensions = {'png','jpg'}   -- Supported image formats
                local split_path = vim.split(filepath:lower(), '.', {plain=true})
                local extension = split_path[#split_path]
                return vim.tbl_contains(image_extensions, extension)
              end
              if is_image(filepath) then
                local term = vim.api.nvim_open_term(bufnr, {})
                local function send_output(_, data, _ )
                  for _, d in ipairs(data) do
                    vim.api.nvim_chan_send(term, d..'\r\n')
                  end
                end
                vim.fn.jobstart(
                  {
                    'chafa', filepath  -- Terminal image viewer command
                  },
                  {on_stdout=send_output, stdout_buffered=true, pty=true})
              else
                require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "Binary cannot be previewed")
              end
            end
          },
        },
      })

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { noremap = true, desc = "[f]ind [f]ile"})
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { noremap = true, desc = "[f]ind files [g]repping through their content"})
      vim.keymap.set('n', '<leader>ft', builtin.treesitter, { noremap = true, desc = "[f]ind from [t]reesitter" })
      vim.keymap.set('n', '<leader>fc', builtin.git_commits, { noremap = true, desc = "[f]ind from [c]ommits"})
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { noremap = true, desc = "[f]ind open [b]uffer"})
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { noremap = true, desc = "[f]ind in [h]elp"})
      vim.keymap.set('n', '<leader>fi', builtin.highlights, { noremap = true, desc = "[f]ind in h[i]lights"})
      vim.keymap.set('n', '<leader>fr', builtin.resume, { noremap = true, desc = "[r]esume previous search"})
    end
  }
}
