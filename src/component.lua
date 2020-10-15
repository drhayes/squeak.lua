local Object = require 'lib.classic'

local Component = Object:extend()

function Component:new()
  -- Set to false so the GameObject doesn't call update and draw.
  self.active = true
  -- Set to true to remove the component on the next GameObject update.
  self.removeMe = false
end

function Component:update(dt) end
function Component:draw() end
function Component:debugDraw() end

-- Called when component is added to GameObject.
function Component:added(parent)
  self.parent = parent
end

-- Called when component is removed from GameObject.
function Component:removed()
  self.parent = nil
end

-- Called when GameObject is added to game.
function Component:gobAdded(gob) end

-- Called when GameObject is removed from game.
function Component:gobRemoved(gob) end

function Component:__tostring()
  return 'Component'
end

return Component
