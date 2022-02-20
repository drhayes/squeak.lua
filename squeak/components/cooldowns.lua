-- Shamelessly stolen from Deepnight
-- https://github.com/deepnight/deepnightLibs/blob/f3803ab24514cc1ffd03ec14b6a51875a4f11a88/src/dn/Cooldown.hx
local PATH = (...):gsub('%.components%.[^%.]+$', '')
local Component = require(PATH .. '.component')

local Cooldowns = Component:extend()

function Cooldowns:new()
  Cooldowns.super.new(self)
  self.list = {}
end

function Cooldowns:get(key)
  for i = 1, #self.list do
    local cooldown = self.list[i]
    if cooldown.key == key then
      return cooldown
    end
  end
  return nil
end

function Cooldowns:set(key, seconds, callback, callbackArg)
  table.insert(self.list, {
    key = key,
    seconds = seconds,
    callback = callback,
    callbackArg = callbackArg,
  })
end

function Cooldowns:has(key)
  return self:get(key) ~= nil
end

function Cooldowns:update(dt)
  Cooldowns.super.update(self, dt)

  local i = 1
  while i <= #self.list do
    local cooldown = self.list[i]
    cooldown.seconds = cooldown.seconds - dt
    if cooldown.seconds <= 0 then
      if cooldown.callback then
        cooldown.callback(cooldown.callbackArg)
      end
      table.remove(self.list, i)
    else
      i = i + 1
    end
  end
end

function Cooldowns:__tostring()
  return 'Cooldowns'
end

return Cooldowns

