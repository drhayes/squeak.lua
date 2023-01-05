local SceneManager = require 'squeak.sceneManager'
local Scene = require 'squeak.scene'
local EventEmitter = require 'squeak.eventEmitter'

describe('SceneManager', function()
  local scene, sm

  before_each(function()
    scene = Scene()
    local eventBus = EventEmitter()
    sm = SceneManager(eventBus)
  end)

  it('can add scenes', function()
    local result = sm:add('first', scene)
    assert.are.equal(scene, result)
    assert.are.equal(sm, scene.parent)
  end)

  it('calls lifecycle methods when switching scenes', function()
    local scene2 = Scene()
    sm:add('first', scene)
    sm:add('second', scene2)
    sm:switch('first')
    sm:draw()

    local leaveCalled = false
    scene.leave = function() leaveCalled = true end
    local enterCalled = false
    scene2.enter = function() enterCalled = true end
    sm:switch('second')
    assert.falsy(leaveCalled)
    assert.falsy(enterCalled)
    sm:draw()
    assert.truthy(leaveCalled)
    assert.truthy(enterCalled)
  end)
end)
