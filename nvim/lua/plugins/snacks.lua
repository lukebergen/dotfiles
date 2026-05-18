return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      image = {},
      picker = {
        sources = {
          files = { exclude = { "node_modules" } },
          grep  = { exclude = { "node_modules" } },
        },
        win = {
          input   = { wo = { winblend = 20 } },
          list    = { wo = { winblend = 20 } },
          preview = { wo = { winblend = 20 } },
        },
      },
    },
    keys = {
      { "<leader>ff", function() Snacks.picker.files()      end, desc = "[f]ind [f]ile" },
      { "<leader>fg", function() Snacks.picker.grep()       end, desc = "[f]ind files [g]repping content" },
      { "<leader>ft", function() Snacks.picker.treesitter() end, desc = "[f]ind from [t]reesitter" },
      { "<leader>fc", function() Snacks.picker.git_log()    end, desc = "[f]ind from [c]ommits" },
      { "<leader>fb", function() Snacks.picker.buffers()    end, desc = "[f]ind open [b]uffer" },
      { "<leader>fk", function() Snacks.picker.keymaps()    end, desc = "[f]ind in [k]eymaps" },
      { "<leader>fh", function() Snacks.picker.help()       end, desc = "[f]ind in [h]elp" },
      { "<leader>fi", function() Snacks.picker.highlights() end, desc = "[f]ind in h[i]lights" },
      { "<leader>fr", function() Snacks.picker.resume()     end, desc = "[r]esume previous search" },
      { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "[f]ind [w]ord under cursor" },
    },
  },
}
