local M = {}

M.absolute_path = function (binaryName)
  local result, stat, type = hs.execute("which " .. binaryName)
  if result then
    return hs.fs.pathToAbsolute(result:gsub("\n$", ""))
  else
    return nil
  end
end

M.winWait = function(app, title, interval, callback)
  local win = app:findWindow(title)
  hs.timer.waitUntil(function()
    win = app:findWindow(title)
    return win
  end, function()
    callback(win)
  end, interval)
end


return M
