local StateMachine = require 'squeak.components.stateMachine'
local State = require 'squeak.components.state'

describe('StateMachine', function()
  local function create()
    return StateMachine({
      one = { stuff = 'two' },
      two = { otherStuff = 'one' },
    })
  end

  it('requires a transition table to generate state names and event names', function()
    local sm = create()
    assert.truthy(sm.stateNames)
    assert.truthy(sm.stateNames['one'])
    assert.truthy(sm.stateNames['two'])
    assert.truthy(sm.eventNames)
    assert.truthy(sm.eventNames['stuff'])
    assert.truthy(sm.eventNames['otherStuff'])
  end)

  it('throws on trying to set invalid state name', function()
    local sm = create()
    assert.has_error(function()
      sm:add('catpants', {})
    end, 'Illegal state added: catpants')
  end)

  it('throws on trying to fire invalid event', function()
    local sm = create()
    assert.has_error(function()
      sm:fireEvent('shoot')
    end, 'Illegal event fired: shoot')
  end)

  it('validates itself when the game object is added to the game', function()
    local sm = create()
    assert.has_error(function()
      sm:gobAdded()
    end)
  end)
end)
