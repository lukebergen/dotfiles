-- honestly, are we really going to use this that much? Start using <leader>fg
-- actually, I think so. <Leader>fg is nice for if you're looking for one specific thing. Rg is useful for if you want to make changes across a bunch of places (and will want your full editor space for each change (using ]q and [q to move between matches in quickfix window)
--vim.api.nvim_create_user_command('Rg', 'silent! grep! <args>|botright cwindow|setlocal nocursorline|redraw!', {nargs = '+', complete = 'file', bar = true})
vim.api.nvim_create_user_command('Rg', function(opts)
  local args = opts.fargs
  local search_term = args[1]
  local sub_dir = args[2] or "."

  if not search_term then
    print("Usage: :Rg <search_term> [sub_dir]")
    return
  end

  local cmd = string.format("rg --vimgrep %s %s", search_term, vim.fn.shellescape(sub_dir))
  vim.fn.setqflist({}, 'r', { title = 'Ripgrep Search', lines = vim.fn.systemlist(cmd) })
  vim.cmd("botright cwindow")
end, {
  nargs = "+",
  complete = "file",
  desc = "Search for a pattern using ripgrep with optional sub-directory"
})

vim.api.nvim_create_user_command('Json', function()
  vim.opt.syntax = "json"
  vim.cmd("%!jq -S .")
end, {desc = 'Convert & format buffer for json'})

vim.api.nvim_create_user_command('Xml', function()
  vim.opt.syntax = "xml"
  vim.cmd("%!xmllint --format --recover -")
end, {desc = 'Convert & format buffer for xml'})

vim.api.nvim_create_user_command('Html', function()
  vim.opt.syntax = "html"
  -- if complains, consider additional blocklevel-tags. Or dig furhter
  local block_tags = "article,aside,details,figcaption,figure,footer,header,main,mark,nav,section,summary,time"
  local inline_tags = "time,mark"
  local cmd = "silent! %!tidy -i -wrap 120 -q --show-body-only yes --show-warnings no --doctype omit --new-blocklevel-tags " .. block_tags .. " --new-inline-tags " .. inline_tags
  vim.cmd(cmd)
end, {desc = 'Convert & format buffer for html'})

vim.api.nvim_create_user_command('Hex', function()
  vim.cmd("%!xxd")
end, {desc = 'Convert & format buffer for hex'})

vim.api.nvim_create_user_command('Nohex', function()
  vim.cmd("%!xxd -r")
end, {desc = 'Convert & format buffer for back to text (from hex)'})

vim.api.nvim_create_user_command('ClearVirt', function()
  vim.api.nvim_buf_clear_namespace(0, -1, 0, -1)
end, {desc = 'Clear Virtual text'})

vim.api.nvim_create_user_command("RC", function()
  vim.cmd('lcd ~/.dotfiles/nvim')
  vim.cmd('e .')
end, {desc = 'Reload [R][C]'})

vim.api.nvim_create_user_command('CT', function()
  local windows = vim.api.nvim_tabpage_list_wins(0)
  for _, win in ipairs(windows) do
    vim.api.nvim_win_close(win, true) -- Close each window forcefully
  end
end, {desc = '[C]lose all splits in [T]ab'})

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
