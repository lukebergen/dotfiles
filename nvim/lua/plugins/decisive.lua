-- leader keys should only be for very commonly used things. Anything that's more
-- like "ehhh, I might want to turn that on or off", should probably be a command
--vim.keymap.set('n', '<Leader>mca', function()
--  require("decisive").align_csv({})
--end, { noremap = true, desc = "[m]y stuff [c]sv [a]lign" })
--vim.keymap.set('n', '<Leader>mcA', function()
--  require("decisive").align_csv_clear({})
--end, { noremap = true, desc = "[m]y stuff [c]sv un[A]lign"})

vim.api.nvim_create_user_command("CSVAlign", function()
  require("decisive").align_csv({})
end, { desc = "align columns in a csv using Decisive"})

vim.api.nvim_create_user_command("CSVUnAlign", function()
  require("decisive").align_csv_clear({})
end, { desc = "clear Decisive's virtual-text csv alignment stuff"})

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
