local Object = require 'lib.classic'
local lume = require 'lib.lume'

local Stack = Object:extend()

function Stack:new()
  self.contents = {}
end

function Stack:push(...)
  if ... then
    local args = { ... }
    for i = 1, #args do
      table.insert(self.contents, args[i])
    end
  end
end

function Stack:pop()
  return table.remove(self.contents)
end

function Stack:top()
  return self.contents[#self.contents]
end

function Stack:clear()
  lume.clear(self.contents)
end

return Stack

