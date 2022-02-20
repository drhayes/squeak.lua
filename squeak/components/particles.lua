local PATH = (...):gsub('%.components%.[^%.]+$', '')
local Component = require(PATH .. '.component')

local Particles = Component:extend()

function Particles:new(ps)
  Particles.super.new(self)
  self.x, self.y = 0, 0
  self.ps = ps
  self.blendMode = 'alpha'
end

function Particles:update(dt)
  self.ps:update(dt)
end

local lg = love.graphics

function Particles:draw()
  Particles.super.draw(self)
  lg.push('all')
  lg.setBlendMode(self.blendMode)
  lg.setColor(1, 1, 1, 1)
  local x, y = self.x + self.parent.x, self.y + self.parent.y
  lg.draw(self.ps, x, y)
  -- lg.setColor(0, 1, 0, .7)
  -- local _, dx, dy = self.ps:getEmissionArea()
  -- lg.rectangle('line', x - dx, y - dy, dx * 2, dy * 2)
  lg.pop()
end

function Particles:__tostring()
  return 'Particles'
end

return Particles
