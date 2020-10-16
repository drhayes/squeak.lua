local Coroutine = require 'squeak.coroutine'
local log = require 'log'
-- Don't log anything please.
log.level = 'fatal'

describe('Coroutine', function()
  it('works at all', function()
    assert.are.equal('table', type(Coroutine))
  end)

  it('can wait one second', function()
    local areWeThereYet = false
    local co = Coroutine(function(co)
      co:wait(1)
      areWeThereYet = true
    end)
    co:update(.2)
    assert.falsy(areWeThereYet)
    co:update(.5)
    assert.falsy(areWeThereYet)
    co:update(1)
    assert.truthy(areWeThereYet)
  end)

  it('can wait until a condition is true', function()
    local switcher = false
    local result = false
    local co = Coroutine(function(co)
      co:waitUntil(function() return switcher end)
      result = true
    end)
    co:update()
    assert.falsy(result)
    co:update()
    assert.falsy(result)
    switcher = true
    co:update()
    assert.truthy(result)
  end)

  it('marks component for removal when coroutine is done', function()
    local co = Coroutine(function() end)
    assert.falsy(co.removeMe)
    co:update()
    assert.truthy(co.removeMe)
  end)

  it('marks component for removal on error', function()
    local co = Coroutine(function() error('death') end)
    assert.falsy(co.removeMe)
    co:update()
    assert.truthy(co.removeMe)
  end)
end)
