-- Note if eventtap randomly stopps working:
-- Before anything, try locking the screen and unlocking again.
-- Can also use below to find what exactly has perma-"SecureInput"ed
-- `ioreg -l -w 0 | grep SecureInput`
-- See this for best info on this issue: https://github.com/Hammerspoon/hammerspoon/issues/1743#issuecomment-631598824

local utils = require("utils")
local canvas = require("hs.canvas")
local silly = require("silly")
local assist = require("assist")

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

--hs.hotkey.bind({"alt"}, "`", function()
--  assist.toggle()
--end)

-- used by clipboard thing but reload command also references this so need to delcar it higher up
local strings = hs.settings.get("registers") or {}

---------------------
-- commander thing --
---------------------
local commands = {}
commands.zoom = function()
  local zoomApp = hs.application.open("zoom.us", 3, true)
  utils.winWait(zoomApp, "Zoom", 0.5, function(zoomWindow)
    hs.eventtap.keyStroke({"ctrl", "cmd"}, "V")
    utils.winWait(zoomApp, "Zoom Meeting", 0.5, function(meetingWin)
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
    -- except for special-k
    local klessStrings = hs.fnutils.copy(strings)
    klessStrings.k = "special-k"
    hs.settings.set("registers", klessStrings)
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
    local tempPasteboard = hs.pasteboard.getContents()
    hs.pasteboard.setContents(strings[char])

    hs.timer.doAfter(5, function()
      hs.pasteboard.setContents(tempPasteboard)
    end)
  end)
end)

-- very much still work in progress. Hence cmd+shift+x instead of cmd+shift+c. Still using iterm2
-- for hotkey window for now I guess. But getting closer
local originalFocus
-- this isn't quite what we're looking for but could be a start
hs.hotkey.bind({"cmd", "shift"}, "x", function()
  -- just do sendkeys or something. Isn't there a way to send an app command keys or something?
  local kitty = hs.application.get("kitty")
  if kitty then
    --hs.eventtap.keyStroke({"cmd", "shift"}, "c", kitty)
    local hotkeyWin = kitty:getWindow("hotkey")
    if hotkeyWin then
      local frame = hotkeyWin:frame()
      if frame.y == 0 then
        frame.y = -10000
        hotkeyWin:setFrame(frame)
        if originalFocus then
          print("found a window to focus: ", originalFocus)
          originalFocus:focus()
          originalFocus = nil
        else
          print("no newFocusWin found")
        end
      else
        originalFocus = hs.window.frontmostWindow()
        frame.y = 0
        hotkeyWin:setFrame(frame)
        --hotkeyWin:orderAbove(nil)
        kitty:activate()
        hotkeyWin:raise()
        hotkeyWin:focus()
      end
    else
      -- todo
      print("debug: ", "window not found")
    end
    --hs.eventtap.keyStrokes("foo", kitty)
  --  hs.task.new("/opt/homebrew/bin/kitty", function(exitCode, stdOut, stdErr)
  --    print("Task completed with exit code: " .. exitCode)
  --    print("Standard output: " .. stdOut)
  --    print("Standard error: " .. stdErr)
  --  end, {"@", "launch", "--type=window"}):start()
  --  --if kitty:isFrontmost() then
  --  --  kitty:hide()
  --  --else
  --  --  kitty:activate()
  --  --end
  --else
  --  hs.application.launchOrFocus("kitty")
  end
end)

-- begin MM specific stuff (if applicable)
local userChoices = safeRequire("mm-test-users") -- only local to MM machine
if userChoices then
  local userChooser
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
-- end MM specific stuff


-- just playing around...
local myCanvas = nil
local isDragging = false
local draggedShape = nil
local dragOffset = {x = 0, y = 0}

local function createCanvas()
  myCanvas = canvas.new({x = 100, y = 100, w = 400, h = 300})

  myCanvas:appendElements({
    {
      type = "rectangle",
      action = "fill",
      fillColor = {red = 1, green = 0, blue = 0, alpha = 0.5},
      frame = {x = "10%", y = "10%", w = "20%", h = "20%"},
      id = "redSquare"
    },
    {
      type = "circle",
      action = "fill",
      fillColor = {red = 0, green = 0, blue = 1, alpha = 0.5},
      center = {x = "70%", y = "50%"},
      radius = "15%",
      id = "blueCircle"
    }
  })

  myCanvas:mouseCallback(function(cv, message, _canvasId, mouseX, mouseY)
    print("mouse callback at all?")
    if message == "mouseDown" then
      local clickedShape = cv:elementAtPoint(mouseX, mouseY)
      if clickedShape then
        print("and we got a shape")
        isDragging = true
        draggedShape = clickedShape
        local frame = cv:elementAttribute(clickedShape, "frame")
        dragOffset.x = mouseX - frame.x
        dragOffset.y = mouseY - frame.y
      end
    elseif message == "mouseUp" then
      print("mouseup")
      isDragging = false
      draggedShape = nil
    elseif message == "mouseMove" and isDragging then
      print("mousedrag")
      cv:elementAttribute(draggedShape, "frame", {
        x = mouseX - dragOffset.x,
        y = mouseY - dragOffset.y,
        w = cv:elementAttribute(draggedShape, "frame").w,
        h = cv:elementAttribute(draggedShape, "frame").h
      })
    end
  end)

  myCanvas:canvasMouseEvents(true, true, true, true)
  myCanvas:show()
end

local function toggleCanvas()
    if myCanvas then
        myCanvas:delete()
        myCanvas = nil
    else
        createCanvas()
    end
end

hs.hotkey.bind({"cmd", "alt"}, "C", toggleCanvas)
