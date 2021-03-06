-------------
-- hotkeys --
-------------
hs.hotkey.bind({"alt", "ctrl"}, "space", function()
  if (hs.spotify.isRunning()) then
    hs.spotify.playpause()
  end
end)

hs.hotkey.bind({"alt"}, "r", function()
  hs.reload()
end)

---------------------
-- commander thing --
---------------------
local commands = {}
commands.zoom = function()
  hs.alert("opening zoom and copying invite link")
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
      else
        hs.alert("what?")
      end
    else
      command = command .. char
      hs.alert.closeSpecific(alert)
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
map = {l = "λ"}
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
x = hs.hotkey.modal.new('alt', 'x') -- copy system clipboard into following key
tempPasteboard = ""
strings = {}
registers = {"a", "s", "d", "f", "g", "h", "h", "h", "h", "h", "j", "k", "l", "z", "x", "c", "v", "b", "n", "m", "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}

c:bind('', 'escape', function() c:exit() end)
v:bind('', 'escape', function() v:exit() end)
x:bind('', 'escape', function() v:exit() end)

hs.fnutils.each(registers, function(char)
  c:bind('', char, function()
    c:exit()

    tempPasteboard = hs.pasteboard.getContents()
    hs.eventtap.keyStroke("cmd", "c")
    strings[char] = hs.pasteboard.getContents()
    hs.pasteboard.setContents(tempPasteboard)
  end)

  v:bind('', char, function()
    v:exit()

    tempPasteboard = hs.pasteboard.getContents()
    hs.pasteboard.setContents(strings[char])
    hs.eventtap.keyStroke("cmd", "v")
    hs.pasteboard.setContents(tempPasteboard)
  end)

  x:bind('', char, function()
    x:exit()

    strings[char] = hs.pasteboard.getContents()
  end)
end)

mb = hs.menubar.new(true)
mb:setTitle("CV")

clear = function() 
  strings = {}
end
mb:setMenu(function() 
  menu = {{title = "clear", fn = clear}, {title = "-----", disabled = true}}

  l = 3
  for k, v in pairs(strings) do
    menu[l] = {title = k .. ": " .. v, disabled = true }
    l = l + 1
  end

  return menu
end)
