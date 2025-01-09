--vim.keymap.set('i', '<C-n>', function()
--  print("doing the thing")
--  local cmp = require("cmp")
--  if cmp.visible() then
--    cmp.mapping.select_next_item()
--  else
--    cmp.mapping.complete()
--  end
--end, { noremap = true, silent = true })

vim.keymap.set('n', '<Leader>mac', function()
  if require("cmp").get_config().completion.autocomplete then
    print("autosuggest off")
    require("cmp").get_config().completion.autocomplete = false
  else
    print("autosuggest on")
    require("cmp").get_config().completion.autocomplete = { "TextChanged" }
  end
end, { desc = "[m]y stuff toggle [a]uto[c]omplete", noremap = true, silent = true })

return {
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    --event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-buffer',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = {
          -- let's see how we feel about this
          -- will automatically show completion options. false requires a keymap to trigger your options
          -- note: autocomplete needs to be either false or a table
          --autocomplete=false, -- off
          --autocomplete = { "TextChanged" }, -- on
          completeopt = 'menu,menuone,noinsert',
        },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        mapping = {
          --['<C-n>'] = cmp.mapping.select_next_item(),
          -- does not work as advertised (unless I'm missing something):
          --['<C-n>'] = function(fallback)
          --  print("doing the thing")
          --  if cmp.visible() then
          --    cmp.mapping.select_next_item()
          --  else
          --    cmp.mapping.complete()
          --  end
          --end,
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<C-c>'] = cmp.mapping.complete(),
        },
        --mapping = cmp.mapping.preset.insert {
        --  ['<C-n>'] = cmp.mapping.select_next_item(),
        --  ['<C-p>'] = cmp.mapping.select_prev_item(),
        --  ['<C-y>'] = cmp.mapping.confirm { select = true },
        --  ['<C-z>'] = cmp.mapping.complete(),
        --  -- default: in command-line mode, for some reason C-z opens suggestions...
        --  ['<C-l>'] = cmp.mapping(function()
        --    if luasnip.expand_or_locally_jumpable() then
        --      luasnip.expand_or_jump()
        --    end
        --  end, { 'i', 's' }),
        --  ['<C-h>'] = cmp.mapping(function()
        --    if luasnip.locally_jumpable(-1) then
        --      luasnip.jump(-1)
        --    end
        --  end, { 'i', 's' }),
        --},
        sources = {
          { name = "buffer" },
          {
            name = 'lazydev',
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        }),
        matching = { disallow_symbol_nonprefix_matching = false }
      })
    end,
  },
}
