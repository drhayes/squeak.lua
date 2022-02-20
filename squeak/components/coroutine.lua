local PATH = (...):gsub('%.components%.[^%.]+$', '')
local Component = require(PATH .. '.component')
local log = require 'lib.log'

local Coroutine = Component:extend()

-- function(co, dt)
--   co:wait(3)
--   co:waitUntil(...)
-- end
function Coroutine:new(func)
  Coroutine.super.new(self)
  self.coroutine = coroutine.create(func)
end

function Coroutine:update(dt)
  local co = self.coroutine
  local ok, message = coroutine.resume(co, self, dt)
  if not ok then
    log.error(message)
  end
  if coroutine.status(co) == 'dead' then
    self.removeMe = true
  end
end

function Coroutine:wait(limit)
  local count = 0
  while count < limit do
    local _, dt = coroutine.yield()
    count = count + dt
  end
end

function Coroutine:waitUntil(condition, arg1, arg2)
  while not condition(arg1, arg2) do
    coroutine.yield()
  end
end

function Coroutine:waitForAnimation(animation)
  while not animation:isPaused() do
    coroutine.yield()
  end
end

function Coroutine:__tostring()
  return 'Coroutine'
end

return Coroutine
