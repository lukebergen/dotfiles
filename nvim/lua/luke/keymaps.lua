-- jk escapes
vim.keymap.set('i', 'jk', '<ESC>')
vim.keymap.set('i', 'jK', '<ESC>')
vim.keymap.set('i', 'Jk', '<ESC>')
vim.keymap.set('i', 'JK', '<ESC>')

-- window management
vim.keymap.set('n', '<Leader>v', '<CMD>vnew<CR>')
vim.keymap.set('n', '<Leader>h', '<CMD>new<CR>')
vim.keymap.set('n', '<Leader>sv', '<CMD>vsplit<CR>')
vim.keymap.set('n', '<Leader>sh', '<CMD>split<CR>')
vim.keymap.set('n', '<C-H>', '<C-W><C-H>')
vim.keymap.set('n', '<C-J>', '<C-W><C-J>')
vim.keymap.set('n', '<C-K>', '<C-W><C-K>')
vim.keymap.set('n', '<C-L>', '<C-W><C-L>')
--vim.keymap.set('n', '<Leader>n', '<CMD>Explore<CR>')
vim.keymap.set('n', '<C-W>0', '<C-W>_<C-W>|')

-- tab management
vim.keymap.set('n', '<Leader>t', '<CMD>tabnew<CR>')
vim.keymap.set('n', '<Leader>1', '1gt')
vim.keymap.set('n', '<Leader>2', '2gt')
vim.keymap.set('n', '<Leader>3', '3gt')
vim.keymap.set('n', '<Leader>4', '4gt')
vim.keymap.set('n', '<Leader>5', '5gt')
vim.keymap.set('n', '<Leader>6', '6gt')

-- TODO: figure out why this sometimes causes results to look like `[1/50]` => `[3/50]` => `[3/50]` => `[5/50]` etc...
-- better `n`
-- Function to jump to the next search result with custom behavior
function NextSearchResult(dir)
  -- Save the current view
  local view = vim.fn.winsaveview()
  -- Jump to the next search result
  local success, _ = pcall(vim.api.nvim_command, 'normal! ' .. dir)
  if not success then
    return
  end
  -- Get the new cursor position
  local new_pos = vim.fn.getpos('.')
  -- Restore the view
  vim.fn.winrestview(view)
  -- Check if the new position is visible in the current view
  local win_height = vim.fn.winheight(0)
  local top_line = view.topline
  local bottom_line = view.topline + win_height - 1

  -- no matter what, jump to the next result
  vim.cmd('normal! ' .. dir)
  if not (new_pos[2] >= top_line and new_pos[2] <= bottom_line) then
    -- But if the location of the new result wasn't in the window, re-center the screen
    vim.cmd('normal! zz')
  end
end

-- Map the 'n' key to the custom function
--vim.keymap.set('n', 'n', ':lua NextSearchResult("n")<CR>', { noremap = true, silent = true })
--vim.keymap.set('n', 'N', ':lua NextSearchResult("N")<CR>', { noremap = true, silent = true })

-- misc
vim.keymap.set('n', '<Leader>r', '<CMD>mode<CR>', { noremap = true, desc = 'clear and redraw screen (commands leave things janky or something)' })
vim.keymap.set('n', '<Leader>c', '<CMD>nohl<CR>', { noremap = true, desc = 'clear highlights (usually after searching)' })
vim.keymap.set('n', '<UP>', '<C-y>', { noremap = true, desc = 'preferred behavior for arrow keys (when we even use them at all)' })
vim.keymap.set('n', '<DOWN>', '<C-e>', { noremap = true, desc = 'preferred behavior for arrow keys (when we even use them at all)' })
vim.keymap.set('n', '<Leader>xl', '<CMD>set relativenumber!<CR>', { noremap = true, desc = 'toggle relative line numbers' })
vim.keymap.set('n', '<Leader>xw', '<CMD>set list!<CR>', { noremap = true, desc = 'toggle whitespace visibility'})
vim.keymap.set('n', '<Leader>xg', '<CMD>Gitsigns toggle_signs<CR>', { noremap = true, desc = 'toggle git gutter signs' })

vim.opt.foldcolumn = 'auto:2' -- a single nesting of folds... fine. But let's go no deeper than that
vim.opt.foldmethod = 'manual'
vim.keymap.set('n', '<Leader>xf', function()
  if vim.wo.foldmethod == 'manual' then
    vim.wo.foldmethod = 'indent'
  else
    vim.wo.foldmethod = 'manual'
  end
end, { noremap = true, desc = 'toggle between manual and indent [f]olds' })

-- neat pair of keymaps, but interferes with super common work flow of visually selecting a bunch of lines and then [J]oining them
-- maybe <C-J>/<C-K>?
-- Move selected lines down
vim.keymap.set("v", "<C-J>", function()
  local count = vim.v.count1
  return string.format(":m '>+%d<CR>gv=gv", count)
end, { expr = true })
--
---- Move selected lines up
vim.keymap.set("v", "<C-K>", function()
  local count = vim.v.count1
  return string.format(":m '<-%d<CR>gv=gv", count + 1)
end, { expr = true })
