-- Shamelessly stolen from Deepnight
-- https://github.com/deepnight/deepnightLibs/blob/f3803ab24514cc1ffd03ec14b6a51875a4f11a88/src/dn/Cooldown.hx
local PATH = (...):gsub('%.components%.[^%.]+$', '')
local Component = require(PATH .. '.component')

local Cooldowns = Component:extend()

function Cooldowns:new()
  Cooldowns.super.new(self)
  self.map = {}
end

function Cooldowns:get(key)
  return self.map[key]
end

function Cooldowns:set(key, seconds, callback, callbackArg)
  -- If calling set on a cooldown that already exists, reset its time.
  if self.map[key] then
    local cooldown = self.map[key]
    cooldown.seconds = seconds
    return
  end

  self.map[key] = {
    seconds = seconds,
    originalSeconds = seconds,
    callback = callback,
    callbackArg = callbackArg,
  }
end

function Cooldowns:reset(key)
  if self.map[key] then
    self.map[key].seconds = self.map[key].originalSeconds
  end
end

function Cooldowns:unset(key)
  self.map[key] = nil
end

function Cooldowns:has(key)
  return self.map[key] ~= nil
end

function Cooldowns:update(dt)
  Cooldowns.super.update(self, dt)

  for key, cooldown in pairs(self.map) do
    cooldown.seconds = cooldown.seconds - dt
    if cooldown.seconds <= 0 then
      if cooldown.callback then
        cooldown.callback(cooldown.callbackArg)
      end
      self.map[key] = nil
    end
  end
end

function Cooldowns:__tostring()
  return 'Cooldowns'
end

return Cooldowns

