local PATH = (...):gsub('%.components%.[^%.]+$', '')
local Component = require(PATH .. '.component')

local Interval = Component:extend()

-- Calls the given function with the given args every intervalInSeconds seconds.
function Interval:new(intervalInSeconds, func, ...)
  Interval.super.new(self)
  self.intervalInSeconds = intervalInSeconds
  self.func = func
  self.args = { ... }
  self.current = 0
end

function Interval:update(dt)
  Interval.super.update(self, dt)
  self.current = self.current + dt
  if self.current >= self.intervalInSeconds then
    self.current = 0
    local result, message = pcall(self.func, unpack(self.args))
    if result == false then
      log.error(message)
    end
  end
end

return Interval
