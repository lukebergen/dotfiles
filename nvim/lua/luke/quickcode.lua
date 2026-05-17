local M = {}

local MODEL_IDS = {
  haiku  = 'claude-haiku-4-5-20251001',
  sonnet = 'claude-sonnet-4-6',
  opus   = 'claude-opus-4-6',
}

local function parse_args(raw)
  local ctx, model, rest = 'none', 'haiku', raw
  while true do
    local flag, val, tail
    flag, val, tail = rest:match('^%s*%-c%s+(%S+)%s*(.*)')
    if flag then ctx, rest = val, tail
    else
      flag, val, tail = rest:match('^%s*%-m%s+(%S+)%s*(.*)')
      if flag then model, rest = val, tail
      else break end
    end
  end
  local prompt = rest:match("^%s*'(.*)'%s*$")
               or rest:match('^%s*"(.*)"s*$')
               or rest:match('^%s*(.-)%s*$')
  return ctx, model, prompt
end

local function get_file_context(buf)
  return table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), '\n')
end

local function get_buffers_context()
  local parts = {}
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(b) and vim.bo[b].buflisted then
      local name = vim.api.nvim_buf_get_name(b)
      if name ~= '' then
        local lines = vim.api.nvim_buf_get_lines(b, 0, 200, false)
        table.insert(parts, ('--- %s (ft: %s) ---\n%s'):format(
          name, vim.bo[b].filetype, table.concat(lines, '\n')))
      end
    end
  end
  return table.concat(parts, '\n\n')
end

local function build_prompt(prompt, ft, ctx_type, buf)
  local lang_instruction = ft ~= ''
    and ('Generate ' .. ft .. ' code.')
    or  'Infer the language from the request. Default to TypeScript if unclear.'

  local instructions = table.concat({
    'You are a code generation assistant.',
    'Return ONLY raw code — no markdown, no code fences, no backticks, no explanations.',
    'Start with the first character of the first line of code.',
    lang_instruction,
  }, ' ')

  local content = prompt
  if ctx_type == 'file' then
    content = 'Current file:\n' .. get_file_context(buf) .. '\n\n' .. prompt
  elseif ctx_type == 'buffers' then
    content = 'Open buffers:\n' .. get_buffers_context() .. '\n\n' .. prompt
  end

  return instructions .. '\n\n' .. content
end

local function run_claude(full_prompt, model_id, on_text, on_done)
  local cmd = {
    'claude', '-p', full_prompt,
    '--model', model_id,
    '--output-format', 'stream-json',
  }

  local partial = ''

  vim.fn.jobstart(cmd, {
    stdout_buffered = false,
    on_stdout = function(_, data)
      for _, line in ipairs(data) do
        -- accumulate partial lines across chunks
        local accumulated = partial .. line
        partial = ''
        if accumulated == '' then goto continue end

        local ok, parsed = pcall(vim.json.decode, accumulated)
        if ok then
          if parsed.type == 'text' and parsed.text then
            on_text(parsed.text)
          end
        else
          -- incomplete JSON line — save for next chunk
          partial = accumulated
        end
        ::continue::
      end
    end,
    on_exit = function() on_done() end,
  })
end

function M.quick_code(opts)
  local ctx_type, model_name, prompt = parse_args(opts.args)
  if not prompt or prompt == '' then
    vim.notify('QC: no prompt provided', vim.log.levels.ERROR)
    return
  end

  local model_id = MODEL_IDS[model_name]
  if not model_id then
    vim.notify('QC: unknown model "' .. model_name .. '", using haiku', vim.log.levels.WARN)
    model_id = MODEL_IDS.haiku
  end

  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  local row = vim.api.nvim_win_get_cursor(win)[1] - 1  -- 0-indexed
  local ft  = vim.bo[buf].filetype

  local full_prompt = build_prompt(prompt, ft, ctx_type, buf)

  -- Insert at start of next line; if current line is blank, reuse it
  local cur_line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1] or ''
  local insert_row
  if cur_line:match('^%s*$') then
    insert_row = row
    vim.api.nvim_buf_set_lines(buf, row, row + 1, false, {''})
  else
    insert_row = row + 1
    vim.api.nvim_buf_set_lines(buf, insert_row, insert_row, false, {''})
  end

  local state = { row = insert_row, col = 0 }

  run_claude(full_prompt, model_id, function(text)
    vim.schedule(function()
      local lines = vim.split(text, '\n', { plain = true })
      vim.api.nvim_buf_set_text(buf, state.row, state.col, state.row, state.col, lines)
      if #lines == 1 then
        state.col = state.col + #lines[1]
      else
        state.row = state.row + #lines - 1
        state.col = #lines[#lines]
      end
    end)
  end, function() end)
end

function M.setup()
  vim.api.nvim_create_user_command('QC', M.quick_code, { nargs = '+' })
end

return M
