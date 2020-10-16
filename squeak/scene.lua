local Object = require 'lib.classic'

local Scene = Object:extend()

function Scene:new(registry, eventBus)
  self.registry = registry
  self.eventBus = eventBus
end

function Scene:enter() end
function Scene:update(dt) end
function Scene:draw() end
function Scene:leave() end

function Scene:subscribe(event, handler)
  self.eventBus:on(event, handler, self)
end


return Scene
