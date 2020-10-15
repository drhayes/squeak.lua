local EventEmitter = require 'squeak.eventEmitter'

describe('EventEmitter', function()
  it('exists', function()
    assert.are.equals(type(EventEmitter), 'table')
    local ee = EventEmitter()
    assert.are.equals(type(ee.emit), 'function')
    assert.are.equals(type(ee.on), 'function')
  end)

  it('allows subscriptions at all', function()
    local ee = EventEmitter()
    local a1
    local function pants(arg1)
      a1 = arg1
    end
    ee:on('cat', pants)
    ee:emit('cat', 234)
    assert.are.equal(a1, 234)
  end)

  it('allows multi-arg subscriptions on repeated calls', function()
    local ee = EventEmitter()
    local o = {}
    local a1, a2
    function o:pants(arg1, arg2)
      a1, a2 = arg1, arg2
    end
    ee:on('cat', o.pants, o, 1)
    ee:emit('cat', 2)
    assert.are.equal(a1, 1)
    assert.are.equal(a2, 2)
    a1 = nil
    a2 = nil
    ee:emit('cat', 3)
    assert.are.equal(a1, 1)
    assert.are.equal(a2, 3)
  end)

  it('works for repeated no-arg emits', function()
    local ee = EventEmitter()
    local o = {}
    local a1, a2, a3
    function o:pants(arg1, arg2, arg3)
      a1, a2, a3 = arg1, arg2, arg3
    end
    ee:on('cat', o.pants, o, 1, 2)
    ee:emit('cat', 3)
    assert.are.equal(a1, 1)
    assert.are.equal(a2, 2)
    assert.are.equal(a3, 3)
    a1 = nil
    a2 = nil
    a3 = nil
    ee:emit('cat', 45)
    assert.are.equal(a1, 1)
    assert.are.equal(a2, 2)
    assert.are.equal(a3, 45)
  end)

  it('no longer has that double unpack bug that Pablo spotted', function()
    local ee = EventEmitter()
    local o = {}
    local a1, a2, a3
    function o:pants(arg1, arg2, arg3)
      a1, a2, a3 = arg1, arg2, arg3
    end
    ee:on('cat', o.pants, o, 1, 2)
    ee:emit('cat', 3)
    assert.are.equal(a1, 1)
    assert.are.equal(a2, 2)
    assert.are.equal(a3, 3)
    a1 = nil
    a2 = nil
    a3 = nil
    ee:emit('cat', 45)
    assert.are.equal(a1, 1)
    assert.are.equal(a2, 2)
    assert.are.equal(a3, 45)
  end)

  it('can unsubscribe a non-existent subscription', function()
    local ee = EventEmitter()
    ee:off('cat')
  end)

  it('can unsubscribe a subscription', function()
    local a1
    local o = {
      thing = function(self, arg1)
        a1 = arg1
      end
    }

    local ee = EventEmitter()
    ee:on('cat', o.thing, o)
    ee:emit('cat', 1)
    assert.are.equal(1, a1)

    a1 = nil
    ee:off('cat', o.thing)
    ee:emit('cat', 1)
    assert.are.equal(nil, a1)
  end)

  it('can create a one-off subscription', function()
    local a1
    local o = {
      thing = function(self, arg1)
        a1 = arg1
      end
    }

    local ee = EventEmitter()
    ee:once('cat', o.thing, o)
    ee:emit('cat', 1)
    assert.are.equal(1, a1)

    a1 = nil
    ee:emit('cat', 1)
    assert.are.equal(nil, a1)
  end)
end)
