local State = require 'squeak.state'

describe('State', function()
  it('works at all', function()
    assert.are.equal('table', type(State))
  end)
end)
