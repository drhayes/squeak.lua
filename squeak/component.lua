local Object = require('lib.classic')

local Component = Object:extend()

function Component:new()
  -- Set to false so the GameObject doesn't call update and draw and onMessage.
  self.active = true
  -- Set to true to remove the component on the next GameObject update.
  self.removeMe = false
end

-- Called once entire game object is made, but before it is added to the game.
function Component:init() end

function Component:preUpdate(dt) end
function Component:update(dt) end
function Component:physicsUpdate(dt) end
function Component:postUpdate(dt) end

function Component:draw() end

function Component:debugDraw() end

-- Called when component is added to GameObject.
function Component:added(parent)
  self.parent = parent
  self.removeMe = false
end

-- Called when component is removed from GameObject.
function Component:removed()
  self.parent = nil
end

-- Called when GameObject is added to game.
function Component:gobAdded() end

-- Called when GameObject is removed from game.
function Component:gobRemoved() end

-- Send a message to the parent.
function Component:sendMessage(message, ...)
  if self.parent then self.parent:sendMessage(message, ...) end
end

-- Called when the GameObject receives a message.
function Component:onMessage(message, ...) end

function Component:__tostring()
  return 'Component'
end

return Component
