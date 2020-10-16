local CoroutineList = require 'squeak.coroutineList'

describe('CoroutineList', function()
  it('works at all', function()
    assert.are.equal('table', type(CoroutineList))
  end)

  it('adds coroutines to itself then removes them', function()
    local list = CoroutineList()
    local result = false
    list:add(function(co)
      co:wait(1)
      result = true
    end)
    local switcher = false
    local result2 = false
    list:add(function(co)
      co:waitUntil(function() return switcher end)
      result2 = true
    end)
    list:update(.2)
    assert.are.equal(2, #list.coroutines)
    assert.falsy(result)
    assert.falsy(result2)
    list:update(.5)
    assert.are.equal(2, #list.coroutines)
    assert.falsy(result)
    assert.falsy(result2)
    list:update(1)
    assert.are.equal(1, #list.coroutines)
    assert.truthy(result)
    assert.falsy(result2)
    switcher = true
    list:update(1)
    assert.are.equal(0, #list.coroutines)
    assert.truthy(result2)
  end)
end)
