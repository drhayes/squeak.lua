local GameObject = require 'gameObject'
local Component = require 'component'

local TestComponent = Component:extend()

describe('gameObject', function()
  local c, g

  before_each(function()
    c = TestComponent()
    g = GameObject()
  end)

  it('works at all', function()
    assert.are.equal('table', type(GameObject))
  end)

  it('sets position on new', function()
    local g = GameObject()
    assert.are.equal(0, g.x)
    assert.are.equal(0, g.y)
    local x, y = 3, 4
    g = GameObject(3, 4)
    assert.are.equal(x, g.x)
    assert.are.equal(y, g.y)
    assert.are.equal('table', type(g.components))
  end)

  it('can add components', function()
    local addedCalled = false
    c.added = function() addedCalled = true end
    local c2 = g:add(c)
    assert.are.equal(1, #g.components)
    assert.is_true(addedCalled)
    assert.are.equal(c2, c)
  end)

  it('can check for components', function()
    g:add(c)
    assert.is_true(g:has(TestComponent))
  end)

  it('can remove previously added components', function()
    local removedCalled = false
    c.removed = function() removedCalled = true end
    g:add(c)
    assert.are.equal(1, #g.components)
    g:remove(c)
    assert.are.equal(0, #g.components)
    assert.is_true(removedCalled)
  end)

  it('calls gobAdded on its components', function()
    local gobAddedCalled = false
    c.gobAdded = function() gobAddedCalled = true end
    g:add(c)
    g:gobAdded()
    assert.is_true(gobAddedCalled)
  end)

  it('calls gobRemoved on its components', function()
    local gobRemovedCalled = false
    c.gobRemoved = function() gobRemovedCalled = true end
    g:add(c)
    g:gobRemoved()
    assert.is_true(gobRemovedCalled)
  end)

  it('calls draw on its components', function()
    local drawCalled = false
    c.draw = function() drawCalled = true end
    g:add(c)
    g:draw()
    assert.is_true(drawCalled)
  end)

  describe('update', function()
    before_each(function()
      g:add(c)
    end)

    it('exists', function()
      assert.are.equal('function', type(GameObject.update))
    end)

    it('updates active components', function()
      c.active = true
      local updateCalled = false
      c.update = function() updateCalled = true end
      g:update()
      assert.is_true(updateCalled)
    end)

    it('does not update inactive components', function()
      c.active = false
      local updateCalled = false
      c.update = function() updateCalled = true end
      g:update()
      assert.is_false(updateCalled)
    end)

    it('removes components marked for removal after update', function()
      assert.are.equal(1, #g.components)
      local order = {}
      c.update = function() table.insert(order, 'update') end
      c.removed = function() table.insert(order, 'removed') end
      c.removeMe = true
      g:update()
      assert.are.equal(0, #g.components)
      assert.are.equal('update', order[1])
      assert.are.equal('removed', order[2])
    end)

    it('does not immediately remove during update loop thus screwing update loop up', function()
      local c2 = TestComponent()
      local cUpdate = 0
      local c2Update = 0
      c.update = function() cUpdate = cUpdate + 1 end
      c.removeMe = true
      c2.update = function() c2Update = c2Update + 1 end
      g:add(c2)
      g:update()
      assert.are.equal(1, cUpdate)
      assert.are.equal(1, c2Update)
    end)
  end)
end)
