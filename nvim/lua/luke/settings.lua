--vim.g.mapleader = ","
vim.g.ctrlp_show_hidden = 1

vim.opt.modeline = false -- see https://threatpost.com/linux-command-line-editors-high-severity-bug/145569/
vim.opt.statusline = '%f%m%=%l/%L:%c'

vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.equalalways = false
vim.opt.incsearch = true
vim.opt.wrap = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.showtabline = 2
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.scrolloff = 3
vim.opt.foldcolumn = 'auto:2' -- a single nesting of folds... fine. But let's go no deeper than that
vim.opt.listchars = { tab = '▸ ', trail = '·', extends = '>', precedes = '<', space = '·' }

vim.api.nvim_create_autocmd("FileType", {
  pattern = "help",
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = {"*"}, -- file types that we don't want newlines to continue a comment
  callback = function()
    vim.opt.formatoptions:remove("c")
    vim.opt.formatoptions:remove("r")
    vim.opt.formatoptions:remove("o")
  end
})


vim.opt.grepprg = 'rg -S --vimgrep'
vim.g.ctrlp_user_command = 'rg %s --files --color=never --glob ""'
vim.g.ctrlp_use_caching = 0

vim.opt.cursorline = true

-- TODO: can we clean this up by just using highlight group "cursorlineNC" (NC being "Not Current")
vim.api.nvim_create_autocmd({"WinEnter"}, {
  callback = function()
    vim.opt_local.cursorline = true
  end
})
vim.api.nvim_create_autocmd({"WinLeave"}, {
  callback = function()
    vim.opt_local.cursorline = false
  end
})

vim.filetype.add({
  extension = {
    puml = 'plantuml',
    pu = 'plantuml'
  }
})

--vim.opt.cmdheight = 0
--vim.api.nvim_create_autocmd("CmdlineEnter", {
--  callback = function()
--    vim.opt.cmdheight = 1
--  end,
--})
--vim.api.nvim_create_autocmd("CmdlineLeave", {
--  callback = function()
--    vim.opt.cmdheight = 0
--  end,
--})
