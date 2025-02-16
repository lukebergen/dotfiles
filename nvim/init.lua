-- do this here first cuz vimwiki is weird and binds leaderww after the fact?
vim.g.mapleader = ","

require("lazyvim")
require("luke")

if vim.g.zen_mode == 1 then
  require("profiles/zen")
end
