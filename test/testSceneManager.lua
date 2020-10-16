local SceneManager = require 'squeak.sceneManager'
local Scene = require 'squeak.scene'

describe('SceneManager', function()
  local scene, sm
  local fakeCamera = {}
  before_each(function()
    scene = Scene()
    sm = SceneManager(fakeCamera)
  end)

  it('works at all', function()
    assert.are.equal('table', type(SceneManager))
  end)

  it('can add scenes', function()
    local result = sm:add('first', scene)
    assert.are.equal(scene, result)
    assert.are.equal(sm, scene.parent)
    assert.are.equal(fakeCamera, scene.camera)
  end)

  it('calls lifecycle methods when switching scenes', function()
    local scene2 = Scene()
    sm:add('first', scene)
    sm:add('second', scene2)
    sm.current = scene
    local leaveCalled = false
    scene.leave = function() leaveCalled = true end
    local enterCalled = false
    scene2.enter = function() enterCalled = true end
    sm:switch('second')
    assert.truthy(leaveCalled)
    assert.truthy(enterCalled)
  end)
end)
