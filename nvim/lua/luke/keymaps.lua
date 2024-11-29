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
vim.keymap.set('n', '<Leader>n', '<CMD>Explore<CR>')
vim.keymap.set('n', '<Leader>ev', '<CMD>Vexplore!<CR>')
vim.keymap.set('n', '<Leader>eh', '<CMD>Hexplore<CR>')
vim.keymap.set('n', '<C-W>0', '<C-W>_<C-W>|')

-- tab management
vim.keymap.set('n', '<Leader>t', '<CMD>tabnew<CR>')
vim.keymap.set('n', '<Leader>1', '1gt')
vim.keymap.set('n', '<Leader>2', '2gt')
vim.keymap.set('n', '<Leader>3', '3gt')
vim.keymap.set('n', '<Leader>4', '4gt')
vim.keymap.set('n', '<Leader>5', '5gt')
vim.keymap.set('n', '<Leader>6', '6gt')

-- hop
local hop = require('hop')
--local directions = require('hop.hint').HintDirection
vim.keymap.set('n', 's', function()
  hop.hint_char1({ direction = nil, current_line_only = false })
end, {remap=true})
--[[
vim.keymap.set('n', 'f', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, {remap=true})
vim.keymap.set('n', 'F', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, {remap=true})
vim.keymap.set({'n', 'v'}, 't', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
end, {remap=true})
vim.keymap.set({'n', 'v'}, 'T', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
end, {remap=true})
--]]

-- better `n`
-- Function to jump to the next search result with custom behavior
function NextSearchResult(dir)
  -- Save the current view
  local view = vim.fn.winsaveview()
  -- Jump to the next search result
  vim.cmd('normal! ' .. dir)
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
vim.keymap.set('n', 'n', ':lua NextSearchResult("n")<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'N', ':lua NextSearchResult("N")<CR>', { noremap = true, silent = true })

-- misc
vim.keymap.set('n', '<Leader>r', '<CMD>mode<CR>')
vim.keymap.set('n', '<Leader>c', '<CMD>nohl<CR>')
vim.keymap.set('n', '<UP>', '<C-y>')
vim.keymap.set('n', '<DOWN>', '<C-e>')

-- Move selected lines down
-- neat binding, but interferes with super common work flow of visually selecting a bunch of lines and then [J]oining them
--vim.keymap.set("v", "J", function()
--  local count = vim.v.count1
--  return string.format(":m '>+%d<CR>gv=gv", count)
--end, { expr = true })
--
---- Move selected lines up
--vim.keymap.set("v", "K", function()
--  local count = vim.v.count1
--  return string.format(":m '<-%d<CR>gv=gv", count + 1)
--end, { expr = true })


-- overriding plugins to make use of their mappings for myself (or keep default behavior like c-y)
vim.keymap.set('n', '<C-Z><C-R>', '<Plug>NetrwRefresh') -- gotta re-map this one away from netrw before we can use it below
--vim.g.user_emmet_leader_key='<C-B>'
