local Component = require 'lib.squeak.component'

local Timer = Component:extend()

-- Calls the given function with the given args after timerInSeconds seconds.
-- The component then removes itself.
function Timer:new(timerInSeconds, func, ...)
  Timer.super.new(self)
  self.timerInSeconds = timerInSeconds
  self.func = func
  self.args = { ... }
  self.current = 0
end

function Timer:update(dt)
  Timer.super.update(self, dt)
  self.current = self.current + dt
  if self.current >= self.timerInSeconds then
    self.active = false
    self.removeMe = true
    local result, message = pcall(self.func, unpack(self.args))
    if result == false then
      log.error(message)
    end
  end
end

function Timer:reset()
  self.current = 0
  self.active = true
  self.removeMe = false
end

function Timer:__tostring()
  return 'Timer'
end

return Timer
