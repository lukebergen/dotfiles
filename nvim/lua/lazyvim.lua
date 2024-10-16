local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  change_detection = {
    notify = false,
  },
})
--[[
require("lazy").setup({
  {"EdenEast/nightfox.nvim",
    config = function()
      vim.cmd('set termguicolors')
      vim.cmd('set background=dark')
      vim.cmd('colorscheme terafox')

      vim.opt.statusline = '%f%m%=%l/%L:%c'

      -- color overrides
      vim.cmd("hi Normal guibg=NONE")
      vim.cmd("hi NormalNC guibg=NONE")
    end
  },
  -- TODO: figure out why which-key window isn't popping up
  -- 'folke/which-key.nvim',
  --'nvim-tree/nvim-web-devicons',
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {"vimwiki/vimwiki", 
    init = function() 
      local default_wiki = {
        path = '~/.vimwiki',
        path_html = '~/.vimwiki/build',
        auto_tags = 1,
      }
      vim.g.vimwiki_list = {default_wiki}
      vim.g.vimwiki_listsyms = ' .oO√'
      vim.g.vimwiki_table_auto_fmt = 0 -- Disable auto formatting tables (it's screwing up my maps)
      vim.g.vimwiki_dir_link = 'index'
    end,
  },
  "tpope/vim-unimpaired",
  "tpope/vim-fugitive",

  -- revisit `olrtg/nvim-emmet` once we've figured out lsp
  --{"mattn/emmet-vim",
  --  config = function()
  --    vim.g.user_emmet_leader_key = '<C-B>'
  --  end
  --},
  --{
  --    'nvim-lualine/lualine.nvim',
  --    dependencies = { 'nvim-tree/nvim-web-devicons' }
  --},
  {
    'smoka7/hop.nvim',
    version = "*",
    opts = {
        keys = 'etovxqpdygfblzhckisuran'
    }
  },
  --"nvim-lualine/lualine.nvim",
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
  }
})

--]]

--return require('packer').startup(function(use)
--  -- Packer can manage itself
--  use 'wbthomason/packer.nvim'
--  use {
--    'nvim-telescope/telescope.nvim', tag = '0.1.3',
--    requires = { {'nvim-lua/plenary.nvim'} }
--  }
--  use 'mattn/emmet-vim'
--  use 'isRuslan/vim-es6'
--  use 'vimwiki/vimwiki'
--  use 'tpope/vim-unimpaired'
--  use 'tpope/vim-fugitive'
--  use {
--    'nvim-lualine/lualine.nvim',
--    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
--  }
--  use {
--    'smoka7/hop.nvim',
--    tag = '*', -- optional but strongly recommended
--    config = function()
--      -- you can configure Hop the way you like here; see :h hop-config
--      require'hop'.setup { }
--    end
--  }
--  use({
--    "kylechui/nvim-surround",
--    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
--    config = function()
--        require("nvim-surround").setup({
--            -- Configuration here, or leave empty to use defaults
--        })
--    end
--  })
--end)
