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
          --autocomplate=true,
          autocomplete = false,
          completeopt = 'menu,menuone,noinsert',
        },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!

        --[[ my notes/thoughts:
          auto-suggest: mixed feelings. Will jump back and forth to decide if I like it or not. But...
          we do want consistent mappings between each option so that muscle memory doesn't get a vote. Soo...
          c-n / c-p: yes. Obvious. next/previous suggestion
          c-l: accept completion
          ~c-y: open suggestions (when auto-suggest is off)~

          This means giving up c-l and c-h for navigating a snippet's expansion. But honestly, I
          like vim for its motions. Do we really need mappings to jump around within a snippet template?
          ... or not even. c-n / c-p will open completion if not open already which frees up c-y
          though I still kind of like c-l for accepting completion instead of 'y' and I don't hate
          giving up snippet navigation anyway...
          only problem: cannot for the life of me get the same behavior in command line mode
          C-z brings it up for whatever reason... good enough for now till we can dig in further?
        ]]--
        mapping = {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-l>'] = cmp.mapping.confirm { select = true },
          -- default: in command-line mode, for some reason C-z opens suggestions...
        },
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
