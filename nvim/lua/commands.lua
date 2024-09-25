-- honestly, are we really going to use this that much? Start using <leader>fg
vim.api.nvim_create_user_command('Rg', 'silent! grep! <args>|botright cwindow|setlocal nocursorline|redraw!', {nargs = '+', complete = 'file', bar = true})

vim.api.nvim_create_user_command('Json', function()
  vim.opt.syntax = "json"
  vim.cmd("%!jq -S .")
end, {})

vim.api.nvim_create_user_command('Xml', function()
  vim.opt.syntax = "xml"
  vim.cmd("%!xmllint --format --recover -")
end, {})

function show_hi()
  local line = vim.fn.line(".")
  local col = vim.fn.col(".")
  local synID = vim.fn.synID(line, col, 1)
  local synName = vim.fn.synIDattr(synID, "name")
  local transName = vim.fn.synIDattr(vim.fn.synIDtrans(synID), "name")
  
  print(synName .. " -> " .. transName)
end
