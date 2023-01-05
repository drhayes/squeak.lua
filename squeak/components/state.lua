local Object = require 'lib.classic'

local State = Object:extend()

function State:enter() end
function State:update(dt, event) end
function State:draw() end
function State:leave() end
function State:onMessage(event, message, ...) end

return State
