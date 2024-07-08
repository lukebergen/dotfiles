--vim.g.mapleader = ","
vim.g.ctrlp_show_hidden = 1

vim.opt.modeline = false -- see https://threatpost.com/linux-command-line-editors-high-severity-bug/145569/

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

-- vimwiki stuff
--local default_wiki = {path = '~/.vimwiki/default'}
--local othana_wiki = {path = '~/.vimwiki/othana'}
--local nest_wiki = {path = '~/.vimwiki/nest'}
--vim.g.vimwiki_list = {default_wiki, othana_wiki, nest_wiki}
--vim.g.vimwiki_listsyms = ' .oO√'
--vim.g.vimwiki_table_auto_fmt = 0 -- Disable auto formatting tables (it's screwing up my maps)
--vim.g.vimwiki_dir_link = 'index'
