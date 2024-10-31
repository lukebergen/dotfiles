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

-- vimwiki stuff
--local default_wiki = {path = '~/.vimwiki/default'}
--local othana_wiki = {path = '~/.vimwiki/othana'}
--local nest_wiki = {path = '~/.vimwiki/nest'}
--vim.g.vimwiki_list = {default_wiki, othana_wiki, nest_wiki}
--vim.g.vimwiki_listsyms = ' .oO√'
--vim.g.vimwiki_table_auto_fmt = 0 -- Disable auto formatting tables (it's screwing up my maps)
--vim.g.vimwiki_dir_link = 'index'

-- vimwiki stuff
-- also check plugins.lua for some stuff that has to be initialized there

vim.api.nvim_create_autocmd({"BufNewFile"}, {pattern = "*/diary/[0-9-]*.{wiki,md}", callback = function()
  print("autocommand ran")
  local template = {}
  local today = os.date("!%Y-%m-%d")
  -- TODO: this could be cleaner. Also, figure out, from usage, what a good starting template might look like
  if (os.getenv("WIKI_FORMAT") == "md") then
    table.insert(template, string.format("# %s", today))
    table.insert(template, "")
    table.insert(template, ":private-1:")
    table.insert(template, "")
    table.insert(template, "## Today")
    table.insert(template, "")
    table.insert(template, "## Next")
    table.insert(template, "")
  else
    table.insert(template, string.format("[[/]] > [[/diary/diary|diary]] > %s", today))
    table.insert(template, string.format("= %s =", today))
    table.insert(template, "")
    table.insert(template, ":private-1:")
    table.insert(template, "")
    table.insert(template, "== Today ==")
    table.insert(template, "")
    table.insert(template, "== Next ==")
    table.insert(template, "")
  end
  vim.api.nvim_buf_set_lines(0, 0, 0, false, template)
end})


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
