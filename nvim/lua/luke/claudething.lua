local M = {}

local MODEL_IDS = {
  haiku  = 'claude-haiku-4-5-20251001',
  sonnet = 'claude-sonnet-4-6',
  opus   = 'claude-opus-4-6',
}

local function parse_args(raw)
  local ctx, model, rest = 'none', 'haiku', raw
  while true do
    local val, tail
    val, tail = rest:match('^%s*%-c%s+(%S+)%s*(.*)')
    if val then ctx, rest = val, tail
    else
      val, tail = rest:match('^%s*%-m%s+(%S+)%s*(.*)')
      if val then model, rest = val, tail
      else break end
    end
  end
  local prompt = rest:match("^%s*'(.*)'%s*$")
               or rest:match('^%s*"(.*)"%s*$')
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

local function build_prompt(prompt, ft, ctx_type, buf, cursor_row)
  local lang_instruction = ft ~= ''
    and ('The language is ' .. ft .. '.')
    or  'Infer the language. Default to TypeScript if unclear.'

  if ctx_type == 'buffer' then
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    table.insert(lines, cursor_row + 2, '<CURSOR>')  -- insert marker after cursor line
    local system = table.concat({
      'You are a code insertion assistant.',
      'Given a buffer with a <CURSOR> marker and a task, output ONLY the raw code to insert at <CURSOR>.',
      'No prose, no markdown, no code fences, no backticks, no explanations.',
      'Never ask questions. Make all assumptions silently.',
      lang_instruction,
    }, ' ')
    return system .. '\n\nBuffer:\n' .. table.concat(lines, '\n') .. '\n\nTask: ' .. prompt
  end

  local system = table.concat({
    'You are a raw code output machine.',
    'Output ONLY the raw code itself — absolutely no prose, no markdown, no code fences, no backticks, no introductory text, no trailing text, no explanations.',
    'The very first character of your response MUST be the first character of the code.',
    'Never ask questions. Make all assumptions silently.',
    lang_instruction,
  }, ' ')

  local content = prompt
  if ctx_type == 'file' then
    content = 'Current file:\n' .. get_file_context(buf) .. '\n\n' .. prompt
  elseif ctx_type == 'buffers' then
    content = 'Open buffers:\n' .. get_buffers_context() .. '\n\n' .. prompt
  end

  return system .. '\n\n' .. content
end

local function stream_code(model_id, full_prompt, on_text, on_done)
  local partial = ''
  local inserted = ''  -- track cumulative text already sent to on_text
  vim.fn.jobstart({
    'env', '--unset=CLAUDECODE', 'claude', '-p', full_prompt,
    '--model', model_id,
    '--output-format', 'stream-json', '--verbose',
    '--tools', '',
  }, {
    stdout_buffered = false,
    stdin = 'null',
    on_stdout = function(_, data)
      for i, chunk in ipairs(data) do
        if i == 1 then
          partial = partial .. chunk
        else
          local line = partial
          partial = chunk
          if line ~= '' then
            local ok, obj = pcall(vim.json.decode, line)
            if ok and obj.type == 'assistant' and obj.message then
              for _, block in ipairs(obj.message.content or {}) do
                if block.type == 'text' then
                  local new_part = block.text:sub(#inserted + 1)
                  if new_part ~= '' then
                    on_text(new_part)
                    inserted = block.text
                  end
                end
              end
            end
          end
        end
      end
    end,
    on_stderr = function(_, data)
      local msg = table.concat(data, '\n')
      if msg ~= '' then
        vim.notify('[QC] ' .. msg, vim.log.levels.WARN)
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

  local full_prompt = build_prompt(prompt, ft, ctx_type, buf, row)

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

  local spinner_frames = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
  local spinner_idx = 1
  vim.api.nvim_buf_set_lines(buf, insert_row, insert_row + 1, false, { spinner_frames[1]})
  local timer = vim.fn.timer_start(80, function(_)
    spinner_idx = (spinner_idx % #spinner_frames) + 1
    vim.api.nvim_buf_set_lines(buf, insert_row, insert_row + 1, false, { spinner_frames[spinner_idx]})
  end, { ['repeat'] = -1 })

  local first_text = true
  stream_code(model_id, full_prompt, function(text)
    vim.schedule(function()
      if first_text then
        first_text = false
        vim.fn.timer_stop(timer)
        vim.api.nvim_buf_set_lines(buf, insert_row, insert_row + 1, false, { '' })
      end
      local lines = vim.split(text, '\n', { plain = true })
      vim.api.nvim_buf_set_text(buf, state.row, state.col, state.row, state.col, lines)
      if #lines == 1 then
        state.col = state.col + #lines[1]
      else
        state.row = state.row + #lines - 1
        state.col = #lines[#lines]
      end
    end)
  end, function()
    vim.schedule(function() vim.fn.timer_stop(timer) end)
  end)
end

vim.api.nvim_create_user_command('QC', M.quick_code, { nargs = '+' })

return M
