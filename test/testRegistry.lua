local Registry = require 'squeak.registry'

describe('Registry', function()
  it('works at all', function()
    assert.are.equal('table', type(Registry))
  end)

  it('holds things and gives them back', function()
    local reg = Registry()
    local thing = {}
    reg:add('cats', thing)
    assert.are.equal(thing, reg:get('cats'))
    assert.falsy(reg:get('dogs'))
  end)
end)
