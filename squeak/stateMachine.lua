local PATH = (...):gsub('%.[^%.]+$', '')
local Component = require(PATH .. '.component')

local StateMachine = Component:extend()

function StateMachine:new()
  StateMachine.super.new(self)
  self.states = {}
end

function StateMachine:add(name, state)
  self.states[name] = state
  state.parent = self
  if not self.initial then
    self.initial = state
  end
  return state
end

function StateMachine:switch(name)
  local newState = self.states[name]
  if not newState then
    log.error('no state named', name)
    return
  end
  if self.current then
    self.current:leave()
  end
  self.current = newState
  self.current:enter()
end

function StateMachine:gobAdded(gob)
  StateMachine.super.gobAdded(self, gob)
  if not self.current then
    self.current = self.initial
    self.current:enter()
  end
end

function StateMachine:update(dt)
  StateMachine.super.update(self, dt)

  local transitionTo = self.current:update(dt)
  if transitionTo then self:switch(transitionTo) end
end

function StateMachine:draw()
  StateMachine.super.draw(self)
  if not self.current then return end
  self.current:draw()
end

function StateMachine:isInState(name)
  return self.current == self.states[name]
end

function StateMachine:__tostring()
  return 'StateMachine'
end

return StateMachine
