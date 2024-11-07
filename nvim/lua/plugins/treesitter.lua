return {
  "nvim-treesitter/nvim-treesitter",
  tag = "v0.9.2",
  build = function()
      require("nvim-treesitter.install").update({ with_sync = true })()
  end,
  --event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    require("nvim-treesitter.configs").setup({
      -- Enable syntax highlighting
      sync_install = true,
      highlight = {
        enable = true,
      },
      -- Enable indentation
      indent = { enable = false },
      -- Ensure these language parsers are installed
      ensure_installed = {
        "c",
        "cpp",
        "csv",
        "comment",
        "html",
        "javascript",
        "typescript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "rust",
        "vim",
        "vimdoc",
        --"plantuml",  -- ehhhh we'll let polyglot handle it the old-school way
      },

      -- some example configuration

      -- Enable incremental selection
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = "<C-s>",
          node_decremental = "<C-backspace>",
        },
      },
      ---- Enable text objects
      --textobjects = {
      --  select = {
      --    enable = true,
      --    lookahead = true,
      --    keymaps = {
      --      ["af"] = "@function.outer",
      --      ["if"] = "@function.inner",
      --      ["ac"] = "@class.outer",
      --      ["ic"] = "@class.inner",
      --    },
      --  },
      --  move = {
      --    enable = true,
      --    set_jumps = true,
      --    goto_next_start = {
      --      ["]m"] = "@function.outer",
      --      ["]]"] = "@class.outer",
      --    },
      --    goto_next_end = {
      --      ["]M"] = "@function.outer",
      --      ["]["] = "@class.outer",
      --    },
      --    goto_previous_start = {
      --      ["[m"] = "@function.outer",
      --      ["[["] = "@class.outer",
      --    },
      --    goto_previous_end = {
      --      ["[M"] = "@function.outer",
      --      ["[]"] = "@class.outer",
      --    },
      --  },
      --},
    })
  end,
}
