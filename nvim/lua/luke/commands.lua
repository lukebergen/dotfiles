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

vim.api.nvim_create_user_command('Hex', function()
  vim.cmd("%!xxd")
end, {})

vim.api.nvim_create_user_command('Nohex', function()
  vim.cmd("%!xxd -r")
end, {})

vim.api.nvim_create_user_command('ClearVirt', function()
  vim.api.nvim_buf_clear_namespace(0, -1, 0, -1)
end, {})

vim.api.nvim_create_user_command("RC", function()
  vim.cmd('lcd ~/.dotfiles/nvim')
  vim.cmd('e .')
end, {})

vim.api.nvim_create_user_command('VimwikiDiaryGenerateIndex', function()
  vim.cmd("VimwikiDiaryIndex")
  vim.cmd("VimwikiDiaryGenerateLinks")
  vim.cmd("w")
end, {})

vim.api.nvim_create_user_command("SS", function()
  vim.cmd('SessionSave')
end, {})

vim.api.nvim_create_user_command("SR", function()
  vim.cmd('SessionRestore')
end, {})

vim.api.nvim_create_user_command("UrlDecode", function(opts)
  local param = opts.args
  print(string.char(tonumber(param, 16)))
end, {nargs = 1, desc = "print arg1 url decoded"})

vim.api.nvim_create_user_command("UrlEncode", function(opts)
  local param = opts.args
  print(string.format("%02X", string.byte(param)))
end, {nargs = 1, desc = "print arg1 url encoded"})

vim.api.nvim_create_user_command("Encrypt", function(opts)
  local l = vim.fn.getline(opts.line1)
  local l2 = vim.fn.getline(opts.line2)
  print(l)
  print(l2)
end, {range = 1, desc = "Encrypt the visual selection with a passphrase"})
