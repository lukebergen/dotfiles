-- TODO: get this (or something like it) working

return {
  {
    "nvim-neotest/neotest",
    enabled = false,
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-jest",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require('neotest-jest')({
            --jestCommand = "npm test --",
            jestCommand = require('neotest-jest.jest-util').getJestCommand(vim.fn.expand '%:p:h'),
            --jestConfigFile = "custom.jest.config.ts",
            env = { CI = true },
            cwd = function(path)
              return vim.fn.getcwd()
            end,
          }),
        }
      })
    end,
  }
}
