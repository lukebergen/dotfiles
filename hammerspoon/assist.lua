-- goal here: keyboard shortcut to instant LLM assistant

-- kitty --config ~/.config/kitty/float.conf
-- vim --cmd "let g:zen_mode = 1" -c LLM

local M = {}

M.toggle = function()
  local pidFile = os.getenv("HOME") .. "/.local/state/kitty/assist.pid"
  local file = io.open(pidFile, "r")
  if file then
    local pidStr = file:read("*all")
    file:close()
    local pid = tonumber(pidStr:match("^%s*(%d+)"))
    if pid then
      local app = hs.application.applicationForPID(pid)
      if app then
        if app:isHidden() then
          app:unhide()
          app:setFrontmost()
        else
          app:hide()
        end
      else
        hs.alert("womp womp")
      end
    else
      hs.alert("Couldn't find assist window pid file")
    end
  else
    hs.alert("assist pid file not found or not openable")
  end

  --local window = hs.window.find("float_assist")
  --if not window then
  --  hs.alert("window not found")
  --else
  --  hs.alert("outter else")
  --  if window:isVisible() then
  --    hs.alert("inner if")
  --    window:hide()
  --  else
  --    hs.alert("inner else")
  --    window:show()
  --  end
  --end
end


return M
