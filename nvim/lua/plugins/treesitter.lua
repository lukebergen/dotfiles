return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({})

      -- nvim-treesitter main no longer supports ensure_installed.
      -- Check for missing parsers on startup and install them.
      local wanted = {
        "cpp", "csv", "comment",
        "javascript", "typescript", "tsx",
        "json", "python", "rust",
      }
      local installed = require("nvim-treesitter").get_installed()
      local missing = vim.tbl_filter(function(l)
        return not vim.list_contains(installed, l)
      end, wanted)
      if #missing > 0 then
        require("nvim-treesitter").install(missing)
      end

      -- nvim-treesitter no longer enables highlighting (parser installer only now).
      -- Neovim 0.12 bundles c, lua, markdown, markdown_inline, query, vim, vimdoc
      -- and its own ftplugins handle those automatically.
      -- Non-bundled languages need this explicit autocmd.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "cpp", "csv", "javascript", "typescript", "typescriptreact", "json", "python", "rust" },
        callback = function() pcall(vim.treesitter.start) end,
      })
    end,
  },
}
