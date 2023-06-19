local GobsList = require('squeak.gobsList')
local GameObject = require('squeak.gameObject')

local CustomGameObject = GameObject:extend()

describe('gobsList', function()
  local gobs

  before_each(function()
    gobs = GobsList()
  end)

  it('adds and removes game objects during update cycle', function()
    local gob = GameObject()
    assert.are.equal(0, #gobs.gobs)
    gobs:add(gob)
    assert.are.equal(0, #gobs.gobs)
    gobs:update()
    assert.are.equal(0, #gobs.gobs)
    gobs:postUpdate()
    assert.are.equal(1, #gobs.gobs)
    gobs:remove(gob)
    assert.are.equal(1, #gobs.gobs)
    gobs:update()
    assert.are.equal(1, #gobs.gobs)
    gobs:postUpdate()
    assert.are.equal(0, #gobs.gobs)
  end)

  it('calls GameObject lifecycle methods during addition and removal', function()
    local gob = GameObject()
    local addedCalled, removedCalled = false, false
    gob.gobAdded = function()
      addedCalled = true
    end
    gob.gobRemoved = function()
      removedCalled = true
    end
    gobs:add(gob)
    assert.falsy(addedCalled)
    gobs:update()
    assert.falsy(addedCalled)
    gobs:postUpdate()
    assert.truthy(addedCalled)
    gobs:remove(gob)
    assert.falsy(removedCalled)
    gobs:update()
    assert.falsy(removedCalled)
    gobs:postUpdate()
    assert.truthy(removedCalled)
  end)

  it('clears game objects', function()
    local gob1 = GameObject()
    local gob2 = GameObject()
    gobs:add(gob1)
    gobs:add(gob2)
    gobs:postUpdate()
    assert.are.equal(2, #gobs.gobs)
    gobs:clear()
    assert.are.equal(0, #gobs.gobs)
  end)

  it('can use a custom sort for game objects', function()
    gobs.gobCompare = function(a, b)
      return a.level < b.level
    end
    local g1 = GameObject()
    local g2 = GameObject()
    local g3 = GameObject()
    g1.level = 100
    g2.level = 50
    g3.level = 0
    gobs:add(g1)
    gobs:add(g2)
    gobs:add(g3)
    assert.are.equal(0, #gobs.gobs)
    gobs:postUpdate()
    assert.are.equal(g3, gobs.gobs[1])
    assert.are.equal(g2, gobs.gobs[2])
    assert.are.equal(g1, gobs.gobs[3])
  end)

  it('removes a game object marked for removal', function()
    local gob = GameObject()
    gobs:add(gob)
    gobs:postUpdate()
    assert.are.equal(1, #gobs.gobs)
    gob.removeMe = true
    gobs:postUpdate()
    assert.are.equal(0, #gobs.gobs)
  end)

  it('can find first of a type', function()
    local g1 = GameObject()
    local g2 = GameObject()
    local custom = CustomGameObject()
    gobs:add(g1)
    gobs:add(g2)
    gobs:add(custom)
    gobs:postUpdate()
    assert.are.equal(custom, gobs:findFirst(CustomGameObject))
  end)
end)
