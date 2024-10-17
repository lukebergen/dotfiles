return {
  {
    "vimwiki/vimwiki",
    enabled = true,
    init = function() 
      local wiki = {
        path = '~/.vimwiki',
        path_html = '~/.vimwiki/build',
        auto_tags = 1,
      }

      local wikiMd = {
        path = '~/.vimwiki-md',
        path_html = '~/.vimwiki-md/build',
        syntax = 'markdown',
        ext = '.md',
        auto_tags = 1,
      }

      if (os.getenv("WIKI_FORMAT") == "md") then
        vim.g.vimwiki_list = {wikiMd}
        vim.g.vimwiki_markdown_link_ext = 1
      else
        vim.g.vimwiki_list = {wiki}
        vim.g.vimwiki_listsyms = ' .oO√'
        vim.g.vimwiki_table_auto_fmt = 0 -- Disable auto formatting tables (it's screwing up my maps)
        vim.g.vimwiki_dir_link = 'index'
      end

      -- vim.g.vimwiki_dir_link = 'index'
    end
  }
}
