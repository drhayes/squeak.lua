local Object = require 'classic'

local Scene = Object:extend()

function Scene:new(registry, eventBus)
  self.registry = registry
  self.eventBus = eventBus
  self.events = {}
end

-- Called the when entering the scene from another scene.
function Scene:enter()
  for event, handler in pairs(self.events) do
    self.eventBus:on(event, handler, self)
  end
end

-- Called when coming back to the scene after another scene's pop.
function Scene:restore() end

-- The core loop, called every frame.
function Scene:update(dt) end

-- Core loop, called to draw everything.
function Scene:draw() end

-- Called every time the scene is left (in a switch or a push)
function Scene:leave()
  for event, handler in pairs(self.events) do
    self.eventBus:off(event, handler)
  end
end

function Scene:subscribe(event, handler)
  self.events[event] = handler
end

function Scene:isCurrent()
  if not self.parent then return false end
  return self.parent.sceneStack:top() == self
end

return Scene
