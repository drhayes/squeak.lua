local PATH = (...):gsub('%.components%.[^%.]+$', '')
local Component = require(PATH .. '.component')

local function throttle(f, waitSeconds)
  local current = 0

  local throttled = function(...)
    if current > 0 then return end
    current = waitSeconds
    return f(...)
  end

  local update = function(dt)
    if current < 0 then return end
    current = current - dt
  end

  return throttled, update
end

local ThrottledFuction = Component:extend()

function ThrottledFuction:new(func, waitSeconds)
  ThrottledFuction.super.new(self)
  self.func, self.throttle = throttle(func, waitSeconds)
end


function ThrottledFuction:update(dt)
  ThrottledFuction.super.update(self, dt)
  self.throttle(dt)
end


function ThrottledFuction:__tostring()
  return 'ThrottledFuction'
end

return ThrottledFuction
