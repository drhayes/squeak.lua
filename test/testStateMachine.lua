local StateMachine = require 'squeak.stateMachine'
local State = require 'squeak.state'

describe('StateMachine', function()
  local s, sm

  before_each(function()
    s = State()
    sm = StateMachine()
  end)

  it('works at all', function()
    assert.are.equal('table', type(StateMachine))
  end)

  it('sets a state as initial when first added', function()
    sm:add('cats', s)
    assert.are.equal(s, sm.initial)
  end)

  it('calls lifecycle methods when switching', function()
    local s2 = State()
    sm:add('first', s)
    sm:add('second', s2)
    sm.current = s
    local leaveCalled = false
    s.leave = function() leaveCalled = true end
    local enterCalled = false
    s2.enter = function() enterCalled = true end
    sm:switch('second')
    assert.truthy(leaveCalled)
    assert.truthy(enterCalled)
  end)

  it('transitions during update', function()
    s.update = function() return 'second' end
    local s2 = State()
    local leaveCalled = false
    s.leave = function() leaveCalled = true end
    local enterCalled = false
    s2.enter = function() enterCalled = true end
    sm:add('first', s)
    sm:add('second', s2)
    sm.current = s
    sm:update()
    assert.truthy(leaveCalled)
    assert.truthy(enterCalled)
  end)

  it('sets initial to current on gobAdded', function()
    sm:add('first', s)
    local enterCalled = false
    s.enter = function() enterCalled = true end
    assert.are.equal(s, sm.initial)
    assert.falsy(sm.current)
    sm:gobAdded()
    assert.truthy(enterCalled)
    assert.are.equal(s, sm.current)
  end)
end)
