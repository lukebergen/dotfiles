return {
  {
    "gruvw/strudel.nvim",
    -- Load when a .str file is opened (matched by extension, not filetype,
    -- so we don't load for every .js file)
    event = { "BufReadPre *.str", "BufNewFile *.str" },
    build = "npm install",
    config = function()
      require("strudel").setup({
        ui = {
          maximise_menu_panel = true,
          hide_menu_panel = true,
          hide_top_bar = true,
          hide_code_editor = true,
          hide_error_display = false,
        },
        update_on_save = true,
        sync_cursor = false,
        report_eval_errors = true,
        headless = true,
        browser_data_dir = vim.fn.expand("~/.cache/strudel-nvim"),
      })

      local function attach_strudel_keymaps(bufnr)
        local s = require("strudel")
        local function opts(desc)
          return { buffer = bufnr, desc = "Strudel: " .. desc }
        end
        vim.keymap.set("n", "<leader>sl", s.launch,     opts("launch browser"))
        vim.keymap.set("n", "<leader>st", s.toggle,     opts("toggle playback"))
        vim.keymap.set("n", "<leader>su", s.update,     opts("push buffer update"))
        vim.keymap.set("n", "<leader>ss", s.stop,       opts("stop playback"))
        vim.keymap.set("n", "<leader>sx", s.execute,    opts("execute current buffer"))
        vim.keymap.set("n", "<leader>sb", s.set_buffer, opts("set active buffer"))
        vim.keymap.set("n", "<leader>sq", s.quit,       opts("quit browser"))
      end

      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function() require("strudel").quit() end,
      })

      -- BufReadPre (our load trigger) fires before BufReadPost, so by the time
      -- BufReadPost fires for the first .str file, this autocmd is already registered.
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
        pattern = "*.str",
        callback = function(ev) attach_strudel_keymaps(ev.buf) end,
      })
    end,
  }
}
