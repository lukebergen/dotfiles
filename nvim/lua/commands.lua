-- honestly, are we really going to use this that much? Start using <leader>fg
-- actually, I think so. <Leader>fg is nice for if you're looking for one specific thing. Rg is useful for if you want to make changes across a bunch of places (and will want your full editor space for each change (using ]q and [q to move between matches in quickfix window)
vim.api.nvim_create_user_command('Rg', 'silent! grep! <args>|botright cwindow|setlocal nocursorline|redraw!', {nargs = '+', complete = 'file', bar = true})

vim.api.nvim_create_user_command('Json', function()
  vim.opt.syntax = "json"
  vim.cmd("%!jq -S .")
end, {})

vim.api.nvim_create_user_command('Xml', function()
  vim.opt.syntax = "xml"
  vim.cmd("%!xmllint --format --recover -")
end, {})

vim.api.nvim_create_user_command('ClearVirt', function()
  vim.api.nvim_buf_clear_namespace(0, -1, 0, -1)
end, {})

vim.api.nvim_create_user_command("RC", function()
  vim.cmd('lcd ~/.dotfiles/nvim')
  vim.cmd('e .')
end, {})
