return {
  {
    "EdenEast/nightfox.nvim",
    config = function()
      local palette = require("nightfox.palette.terafox").palette

      require("nightfox").setup({
        groups = {
          all = {
            WinSeparator = { fg = palette.white.base, bg = NONE }
          }
        }
      })

      vim.cmd('set termguicolors')
      vim.cmd('set background=dark')
      vim.cmd('colorscheme terafox')

      -- color overrides
      vim.cmd("hi Normal guibg=NONE")
      vim.cmd("hi NormalNC guibg=NONE")
      --vim.cmd("hi VertSplit guifg=#ffffff guibg=#ffffff")
      -- vim.cmd("hi WinSeparator guifg=orange")
    end
  }
}
