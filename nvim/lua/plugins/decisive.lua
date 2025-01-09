vim.keymap.set('n', '<Leader>mca', function()
  require("decisive").align_csv({})
end, { noremap = true, desc = "[m]y stuff [c]sv [a]lign" })
vim.keymap.set('n', '<Leader>mcA', function()
  require("decisive").align_csv_clear({})
end, { noremap = true, desc = "[m]y stuff [c]sv un[A]lign"})

return {
  {
    "emmanueltouzery/decisive.nvim",
    lazy=true,
    ft = {'csv'},
    config = function()
      require('decisive').setup{}
    end,
  },
}
