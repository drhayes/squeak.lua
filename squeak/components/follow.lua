local PATH = (...):gsub('%.components%.[^%.]+$', '')
local Component = require(PATH .. '.component')

local Follow = Component:extend()


function Follow:new(gob, offsetX, offsetY)
  Follow.super.new(self)

  self.gob = gob
  self.offsetX = offsetX or 0
  self.offsetY = offsetY or 0
end

function Follow:update(dt)
  Follow.super.update(self, dt)
  self.parent.x = self.gob.x + self.offsetX
  self.parent.y = self.gob.y + self.offsetY
end

function Follow:__tostring()
  return 'Follow'
end

return Follow
