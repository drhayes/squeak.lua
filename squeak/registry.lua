local Object = require 'lib.classic'

local Registry = Object:extend()

function Registry:new()
  self.services = {}
end

function Registry:add(key, instance)
  self.services[key] = instance
  return instance
end

function Registry:get(key)
  return self.services[key]
end

function Registry:exposeGlobals()
  for name, service in pairs(self.services) do
    log.trace('Exposing ' .. name)
    _G[name] = service
  end
end

return Registry
