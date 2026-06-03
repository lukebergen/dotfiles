-- honestly, are we really going to use this that much? Start using <leader>fg
-- actually, I think so. <Leader>fg is nice for if you're looking for one specific thing. Rg is useful for if you want to make changes across a bunch of places (and will want your full editor space for each change (using ]q and [q to move between matches in quickfix window)

--vim.api.nvim_create_user_command('Rg', 'silent! grep! <args>|botright cwindow|setlocal nocursorline|redraw!', {nargs = '+', complete = 'file', bar = true})

vim.api.nvim_create_user_command('Rg', function(opts)
  local cmd = string.format("rg -i --vimgrep %s", opts.args)
  local result = vim.fn.system(cmd)
  local lines = vim.split(result, '\n')

  if #lines > 0 and (lines[#lines] == "" or lines[#lines] == "|| ") then
    table.remove(lines, #lines)
  end
  if #lines == 0 then
    print("Not found")
  end

  vim.fn.setqflist({}, 'r', { title = 'Ripgrep Search', lines = lines})
  vim.cmd("botright cwindow")
end, {
  nargs = "*",
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
  vim.cmd('AutoSession save')
end, {})

vim.api.nvim_create_user_command("SR", function()
  vim.cmd('AutoSession restore')
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

local function encrypt_visual_selection()
  -- Get the password securely
  local password = vim.fn.inputsecret("password: ")
  if password == "" then
    print("Encryption cancelled: No password provided.")
    return
  end

  -- Get the visually selected text
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getline(start_pos[2], end_pos[2])
  local selected_text = table.concat(lines, "\n")

  -- Encrypt the text using openssl
  local encrypted = vim.fn.system(
    { "openssl", "enc", "-aes-256-cbc", "-pbkdf2", "-base64", "-pass", "pass:" .. password },
    selected_text
  )

  -- Replace the visual selection with the encrypted text
  local encrypted_lines = vim.split(encrypted, "\n", { plain = true })
  vim.fn.setline(start_pos[2], encrypted_lines)
  if #encrypted_lines < (end_pos[2] - start_pos[2] + 1) then
    vim.fn.deletebufline(vim.fn.bufnr(), start_pos[2] + #encrypted_lines, end_pos[2])
  end
end

local function decrypt_visual_selection()
  -- Get the password securely
  local password = vim.fn.inputsecret("password: ")
  if password == "" then
    print("Decryption cancelled: No password provided.")
    return
  end

  -- Get the visually selected text
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getline(start_pos[2], end_pos[2])
  local selected_text = table.concat(lines, "\n")

  -- Decrypt the text using openssl
  local decrypted = vim.fn.system(
    { "openssl", "enc", "-aes-256-cbc", "-pbkdf2", "-base64", "-d", "-pass", "pass:" .. password },
    selected_text
  )

  -- Replace the visual selection with the decrypted text
  local decrypted_lines = vim.split(decrypted, "\n", { plain = true })
  vim.fn.setline(start_pos[2], decrypted_lines)

  -- Adjust the range to delete only the remaining lines in the original selection
  local lines_to_remove = (end_pos[2] - start_pos[2] + 1) - #decrypted_lines
  if lines_to_remove > 0 then
    vim.fn.deletebufline(vim.fn.bufnr(), start_pos[2] + #decrypted_lines, start_pos[2] + #decrypted_lines + lines_to_remove - 1)
  end
end

-- Register the commands
vim.api.nvim_create_user_command("Encrypt", encrypt_visual_selection, { range = true })
vim.api.nvim_create_user_command("Decrypt", decrypt_visual_selection, { range = true })
