return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 600,
      -- I tried letting it just take over everything. But annoyingly, `V` started
      -- acting weird. So now we'll just explicitly opt-in for most mappings
      triggers = {
        { "<leader>", mode = { "n", "v" } },
        { "g", mode = { "n", "v" } },
      },
    },
  }
}
