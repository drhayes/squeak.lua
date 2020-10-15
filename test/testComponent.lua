local Component = require 'component'

describe('Component', function()
  it('works at all', function()
    assert.are.equal('table', type(Component))
  end)

  it('starts out active and not marked for removal', function()
    local c = Component()
    assert.truthy(c.active)
    assert.falsy(c.removeMe)
  end)

  it('sets parent when added and unsets it when removed', function()
    local c = Component()
    local parent = {}
    c:added(parent)
    assert.are.equal(parent, c.parent)
    c:removed()
    assert.falsy(c.parent)
  end)
end)
