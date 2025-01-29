local M = {}

M.hideCursor = function()
  io.write("\27[?25l")
end

M.showCursor = function()
  io.write("\27[?25h")
end

local lines = {
  "",
  "     1. Take care of yourself",
  "     2. Take care of your people",
  "     3. Fulfill your commitments",
  "     4. Make no commitments you can't justify",
  "",
}

local function centerYourself()
  local editor_width = vim.o.columns
  local editor_height = vim.o.lines

  local float_width = 50
  local float_height = 6

  local buf = vim.api.nvim_create_buf(false, true) -- Create a new buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = float_width,
    height = float_height,
    row = (editor_height - float_height) / 2,
    col = (editor_width - float_width) / 2,
    style = "minimal",
    border = "rounded", -- consider: single, rounded, and solid
    --title = "mantra",  -- just see how this looks
    --title_pos = "center",
  })

  M.hideCursor()

  local autocmd_id
  local close = function()
    -- using pcall because I'm lazy and can't be bothered to figure out
    -- why it keeps bugging about the buffer not being a valid id.
    -- two things trying to close it at the same time or something?
    pcall(function()
      M.showCursor()
      vim.api.nvim_win_close(win, true)
      vim.api.nvim_buf_delete(buf, {force = true})
      vim.api.nvim_del_autocmd(autocmd_id)
    end)
  end


  autocmd_id = vim.api.nvim_create_autocmd("WinLeave", {
    pattern = "*",
    callback = function()
      if vim.api.nvim_get_current_win() == win then
        close()
      end
    end
  })

  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '', {
    noremap = true,
    silent = true,
    callback = function()
      close()
    end
  })
  vim.api.nvim_buf_set_keymap(buf, 'n', '<ESC>', '', {
    noremap = true,
    silent = true,
    callback = function()
      close()
    end
  })
end

vim.api.nvim_create_user_command('Mantra', centerYourself, {})

return M
