local Scene = require 'squeak.scene'
local EventEmitter = require 'squeak.eventEmitter'

describe('Scene', function()
  it('provides a shortcut for subscribing to events', function()
    local eventBus = EventEmitter()
    local scene = Scene(nil, eventBus)
    local randomEventCalled = false
    scene.onRandomEvent = function(self, arg1)
      assert.are.equal(scene, self)
      assert.are.equal('cats', arg1)
      randomEventCalled = true
    end
    scene:subscribe('randomEvent', scene.onRandomEvent)
    eventBus:emit('randomEvent', 'cats')
    assert.falsy(randomEventCalled)
    -- Now enter the scene, and it'll be subscribed.
    scene:enter()
    eventBus:emit('randomEvent', 'cats')
    assert.truthy(randomEventCalled)
  end)
end)
