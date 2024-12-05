return {
  {
    'smoka7/hop.nvim',
    version = "*",
    config = function()
      local hop = require('hop')
      hop.setup({
        keys = 'etovxqpdygfblzhckisuran'
      })
      --local directions = require('hop.hint').HintDirection
      vim.keymap.set('n', 's', function()
        hop.hint_char1({ current_line_only = false })
      end, {remap=true})

      --[[
      vim.keymap.set('n', 'f', function()
        hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
      end, {remap=true})
      vim.keymap.set('n', 'F', function()
        hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
      end, {remap=true})
      vim.keymap.set({'n', 'v'}, 't', function()
        hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
      end, {remap=true})
      vim.keymap.set({'n', 'v'}, 'T', function()
        hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
      end, {remap=true})
      --]]

    end
  }
}
