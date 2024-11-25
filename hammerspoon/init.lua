-- Note if eventtap randomly stopps working:
-- Before anything, try locking the screen and unlocking again.
-- Can also use below to find what exactly has perma-"SecureInput"ed
-- `ioreg -l -w 0 | grep SecureInput`
-- See this for best info on this issue: https://github.com/Hammerspoon/hammerspoon/issues/1743#issuecomment-631598824

local canvas = require("hs.canvas")
local eventtap = require("hs.eventtap")
local silly = require("silly")

local function safeRequire(moduleName)
  local status, result = pcall(require, moduleName)
  if status then
    return result
  else
    return nil
  end
end

-------------
-- hotkeys --
-------------
hs.hotkey.bind({"alt", "ctrl"}, "space", function()
  if (hs.spotify.isRunning()) then
    hs.spotify.playpause()
  end
end)

-------------
-- helpers --
-------------
winWait = function(app, title, interval, callback)
  win = app:findWindow(title)
  hs.timer.waitUntil(function()
    win = app:findWindow(title)
    return win
  end, function()
    callback(win)
  end, interval)
end

-- used by clipboard thing but reload command also references this so need to delcar it higher up
strings = hs.settings.get("registers") or {}

---------------------
-- commander thing --
---------------------
local commands = {}
commands.zoom = function()
  local zoomApp = hs.application.open("zoom.us", 3, true)
  winWait(zoomApp, "Zoom", 0.5, function(zoomWindow)
    hs.eventtap.keyStroke({"ctrl", "cmd"}, "V")
    winWait(zoomApp, "Zoom Meeting", 0.5, function(meetingWin)
      hs.eventtap.keyStroke({"cmd"}, "I")
    end)
  end)
end

commands.reload = function()
  hs.settings.set("registers", strings)
  hs.reload()
end

commands.clearRegisters = function()
  hs.settings.set("registers", {})
  strings = {}
end

commands.shrug = function()
  hs.eventtap.keyStrokes("¯\\_(ツ)_/¯")
end

commands.sillytime = function()
  silly.toggle()
end

hs.hotkey.bind({"alt"}, "space", function()
  local command = ""
  local alert = hs.alert("", 9999)
  local et
  et = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    local char = event:getCharacters()
    if char == "\r" or event:getKeyCode() == 53 then
      et:stop()
      if alert then
        hs.alert.closeSpecific(alert)
      end

      if char == "\r" and commands[command] then
        commands[command]()
      elseif event:getKeyCode() ~= 53 then
        hs.alert("what?")
      end
    else
      hs.alert.closeSpecific(alert)
      if event:getKeyCode() == 51 then
        command = command:sub(1, -2)
      else
        command = command .. char
      end
      alert = hs.alert(command, 9999)
    end

    return true
  end)
  et:start()
end)

--------------
-- alt keys --
--------------
s = hs.hotkey.modal.new('alt', 's')
s:bind('', 'escape', function() s:exit() end)
map = {l = "λ", d = "◊", j = "👇", h = "👈", l = "👉", k = "👆"}
for key, value in pairs(map) do
  s:bind('', key, function()
    s:exit()
    hs.eventtap.keyStrokes(value)
  end)
end

--------------------------------
-- register-like copy/pasting --
--------------------------------
c = hs.hotkey.modal.new('alt', 'c') -- copy into following key
v = hs.hotkey.modal.new('alt', 'v') -- paste from following key
x = hs.hotkey.modal.new('alt', 'x') -- copy from following key into system clipboard
tempPasteboard = ""
registers = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}

c:bind('', 'escape', function() c:exit() end)
v:bind('', 'escape', function() v:exit() end)
x:bind('', 'escape', function() v:exit(); c:exit(); x:exit(); end)

hs.fnutils.each(registers, function(char)
  c:bind('', char, function()
    c:exit()

    tempPasteboard = hs.pasteboard.getContents()
    hs.eventtap.keyStroke("cmd", "c")
    strings[char] = hs.pasteboard.getContents()
    hs.pasteboard.setContents(tempPasteboard)

    -- backup to settings so on reboot/crash we preserve all our clipboards
    hs.settings.set("registers", strings)
  end)

  v:bind('', char, function()
    v:exit()

    if strings[char] then
      tempPasteboard = hs.pasteboard.getContents()
      hs.pasteboard.setContents(strings[char])
      hs.eventtap.keyStroke("cmd", "v")
      hs.pasteboard.setContents(tempPasteboard)
    end
  end)

  x:bind('', char, function()
    x:exit()

    hs.pasteboard.setContents(strings[char])
  end)
end)

-- begin MM specific stuff (if applicable)
local userChoices = safeRequire("mm-test-users") -- only local to MM machine
if userChoices then
  userChooser = hs.chooser.new(function(choice)
    local tempPasteboard = hs.pasteboard.getContents()
    hs.pasteboard.setContents(choice.email)
    hs.eventtap.keyStroke("cmd", "v")

    if choice.password then
      hs.pasteboard.setContents(choice.password)
    else
      hs.pasteboard.setContents(strings["p"]) -- for convenience, if we've just inserted a test user, probably about to login...
    end

    userChooser:query("")
    hs.timer.doAfter(5, function()
      hs.pasteboard.setContents(tempPasteboard)
    end)
  end)
  userChooser:choices(userChoices)
  userChooser:bgDark(true)
  userChooser:searchSubText(true)
  userChooser:hideCallback(function()
    userChooser:query("")
  end)

  hs.hotkey.bind({"alt"}, "u", function()
    userChooser:show()
  end)
end
