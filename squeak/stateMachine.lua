local PATH = (...):gsub('%.[^%.]+$', '')
local Component = require(PATH .. '.component')
local EventEmitter = require(PATH .. '.eventEmitter')

local StateMachine = Component:extend()

function StateMachine:new(transitionTable)
  StateMachine.super.new(self)
  self.transitionTable = transitionTable
  self.stateNames = {}
  self.eventNames = {}
  self.states = {}
  self.events = EventEmitter()

  -- Find all the legal states and events.
  for stateName, eventTable in pairs(transitionTable) do
    self.stateNames[stateName] = true
    for eventName, _ in pairs(eventTable) do
      self.eventNames[eventName] = true
    end
  end

  -- Bind fireEvent method for passing in State:update.
  self.boundFireEvent = function(eventName) self:fireEvent(eventName) end
end

function StateMachine:add(name, state)
  -- Is this a legal state name?
  if not self.stateNames[name] then
    error('Illegal state added: ' .. name)
  end

  self.states[name] = state
  state.parent = self
  if not self.initial then
    self.initial = name
  end
  return state
end

function StateMachine:fireEvent(eventName)
  -- Is this a legal event name?
  if not self.eventNames[eventName] then
    error('Illegal event fired: ' .. eventName)
  end

  -- Can we transition to another state based on this event?
  -- It's fine if we can't, just ignore in that case.
  local nextState = self.transitionTable[self.current][eventName]
  if not nextState then
    return
  end

  local currentState = self.states[self.current]
  currentState:leave()

  self.events:emit(eventName)

  self.current = nextState
  self.states[self.current]:enter()
end

function StateMachine:addTransition(eventName, fromState, toState)
  self.transitionTable[fromState][eventName] = toState
end

function StateMachine:removeTransition(state, eventName)
  -- Is this a legal event name?
  if not self.eventNames[eventName] then
    error('Illegal event: ' .. eventName .. ' in state: ' .. self.current)
  end

  self.transitionTable[state][eventName] = false
end

function StateMachine:subscribe(eventName, listener, ...)
  self.events:on(eventName, listener, ...)
end

function StateMachine:unsubscribe(eventName, listener)
  self.events:off(eventName, listener)
end

function StateMachine:gobAdded()
  StateMachine.super.gobAdded(self)
  -- Are we missing any states?
  for stateName, _ in pairs(self.stateNames) do
    if not self.states[stateName] then
      error('Missing state ' .. stateName .. ' declared in transition table')
    end
  end

  if not self.current then
    self.current = self.initial
    local state = self.states[self.current]
    state:enter()
  end
end

function StateMachine:update(dt)
  StateMachine.super.update(self, dt)
  if not self.current then return end
  self.states[self.current]:update(dt, self.boundFireEvent)
end

function StateMachine:draw()
  StateMachine.super.draw(self)
  if not self.current then return end
  self.states[self.current]:draw()
end

function StateMachine:isInState(name)
  return self.current == self.states[name]
end

function StateMachine:__tostring()
  return 'StateMachine'
end

return StateMachine
