local canvas = require("hs.canvas")
local eventtap = require("hs.eventtap")

local sillyMode = false

local click = function()
  local mouse = hs.mouse.absolutePosition()

  a = canvas.new{ x = mouse.x - 25, y = mouse.y - 25, h = 50, w = 50 }

  local r1 = hs.math.randomFloat() / 2.0 + 0.5
  local r2 = hs.math.randomFloat() / 2.0 + 0.5
  local g1 = hs.math.randomFloat() / 2.0 + 0.5
  local g2 = hs.math.randomFloat() / 2.0 + 0.5
  local b1 = hs.math.randomFloat() / 2.0 + 0.5
  local b2 = hs.math.randomFloat() / 2.0 + 0.5

  a[1] = {
    coordinates = {
      { x = ".1", y = ".5" },
      { x = ".9", y = ".5", c1x = ".1", c1y = ".1", c2x = ".9", c2y = ".9" },
      { x = ".1", y = ".5", c1x = ".9", c1y = ".1", c2x = ".1", c2y = ".9" },
    },
    fillColor = { red = r1, green = g1, blue = b1},
    type = "segments",
  }

  a[2] = {
    coordinates = {
      { x = ".5", y = ".1" },
      { x = ".5", y = ".9", c1x = ".1", c1y = ".1", c2x = ".9", c2y = ".9" },
      { x = ".5", y = ".1", c1x = ".1", c1y = ".9", c2x = ".9", c2y = ".1" },
    },
    fillColor = { red = r2, green = g2, blue = b2},
    type = "segments",
  }

  a:show()

  a:delete(0.4)
end

-- kinda not very performant. Kept looking laggy. Maybe try storing points and creating a bezier curve or something?
local function move(event)
--  local mouse = hs.mouse.absolutePosition()
--  a = canvas.new{ x = mouse.x - 5, y = mouse.y - 5, h = 10, w = 10 }
--  --a[1] = { type = "circle", fillColor = { red = hs.math.randomFloat(), green = hs.math.randomFloat(), blue = hs.math.randomFloat() } }
--  a[1] = { type = "circle", fillColor = { red = 1, green = 1, blue = 1 } }
--
--  a:show()
--  a:delete(0.5)
end

local mouseMoveTap = eventtap.new({eventtap.event.types.mouseMoved}, move)
local mouseEventTap = eventtap.new({eventtap.event.types.leftMouseDown, eventtap.event.types.rightMouseDown}, click)

local toggle = function()
  sillyMode = not sillyMode
  if sillyMode then
    mouseEventTap:start()
    mouseMoveTap:start()
  else
    mouseEventTap:stop()
    mouseMoveTap:stop()
  end
end

return {
  move = move,
  click = click,
  toggle = toggle
}
