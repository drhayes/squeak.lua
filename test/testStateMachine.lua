local StateMachine = require 'squeak.stateMachine'
local State = require 'squeak.state'

describe('StateMachine', function()
  it('works at all', function()
    assert.are.equal('table', type(StateMachine))
  end)
end)
