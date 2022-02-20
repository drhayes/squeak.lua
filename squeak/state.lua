local Object = require 'lib.classic'

local State = Object:extend()

function State:enter() end
function State:update(dt, event) end
function State:draw() end
function State:leave() end

return State
