return {
  {
    "vimwiki/vimwiki",
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
    end
  }
}
