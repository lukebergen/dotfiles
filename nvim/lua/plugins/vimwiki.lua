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
    end,
    config = function()

      -- to keymap:
      vim.keymap.set('n', '<leader>ww', function()
        if (os.getenv("WIKI_FORMAT") == "md") then
          vim.cmd('lcd ~/.vimwiki-md')
        else
          vim.cmd('lcd ~/.vimwiki')
        end
        vim.cmd('VimwikiIndex')
      end)

      vim.keymap.set('n', '<C-Space>', function()
        vim.cmd('VimwikiToggleListItem')
      end)

      vim.api.nvim_create_autocmd({"BufNewFile"}, {pattern = "*/diary/[0-9-]*.{wiki,md}", callback = function()
        local template = {}
        local today = os.date("!%Y-%m-%d")
        -- TODO: this could be cleaner. Also, figure out, from usage, what a good starting template might look like
        if (os.getenv("WIKI_FORMAT") == "md") then
          table.insert(template, string.format("# %s", today))
          table.insert(template, "")
          table.insert(template, ":private-1:")
          table.insert(template, "")
          table.insert(template, "## Todo")
          table.insert(template, "")
          table.insert(template, "")
          table.insert(template, "## Actual")
        else
          table.insert(template, string.format("[[/]] > [[/diary/diary|diary]] > %s", today))
          table.insert(template, string.format("= %s =", today))
          table.insert(template, "")
          table.insert(template, ":private-1:")
          table.insert(template, "")
          table.insert(template, "== Todo ==")
          table.insert(template, "")
          table.insert(template, "")
          table.insert(template, "== Actual ==")

          -- TODO: copy incomplete stuff from yesterday?
        end
        vim.api.nvim_buf_set_lines(0, 0, 0, false, template)
      end})
    end
  }
}
