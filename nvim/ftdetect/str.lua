vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.str",
  command = "setfiletype javascript",
})
