local Object = require 'classic'
local lume = require 'lume'
local PATH = (...):gsub('%.[^%.]+$', '')
local Coroutine = require(PATH .. '.coroutine')

local CoroutineList = Object:extend()

function CoroutineList:new()
  self.coroutines = {}
  self.removals = {}
end

function CoroutineList:update(dt)
  local removals = self.removals
  lume.clear(removals)
  local coroutines = self.coroutines
  -- Update'em.
  for i = 1, #coroutines do
    local co = coroutines[i]
    co:update(dt)
    if co.removeMe then
      table.insert(removals, co)
    end
  end
  -- Remove'em.
  for i = 1, #removals do
    local co = removals[i]
    lume.remove(self.coroutines, co)
  end
end

function CoroutineList:add(func)
  table.insert(self.coroutines, Coroutine(func))
end

return CoroutineList
