local Object = require 'classic'

local function push (t, ...)
  local pushed = select('#', ...)

  for i = 1, pushed do
    t[t.n + i] = select(i, ...)
  end

  return t.n + pushed
end

local function clean (t, n)
  for i = (t.n + 1), n do
    t[i] = nil
  end
end

local EventEmitter = Object:extend()

function EventEmitter:emit(eventName, ...)
  if not self.subscribers then return end
  local subscriptions = self.subscribers[eventName]
  if not subscriptions or #subscriptions == 0 then return end

  for i = 1, #subscriptions do
    local sub = subscriptions[i]
    local ok, message

    if sub.args then
      local n = push(sub.args, ...)
      ok, message = pcall(sub.listener, unpack(sub.args, 1, n))
      clean(sub.args, n)
    else
      ok, message = pcall(sub.listener, ...)
    end

    if not ok then
      log.error(eventName, message)
    end
  end
end

function EventEmitter:on(eventName, listener, ...)
  if not self.subscribers then
    self.subscribers = setmetatable({}, { __k = 'kv' })
  end

  if not self.subscribers[eventName] then
    self.subscribers[eventName] = setmetatable({}, { __k = 'kv' })
  end

  local newSub = setmetatable({
    listener = listener,
  }, { __k = 'kv' })

  local n = select('#', ...)
  if n > 0 then
    newSub.args = { n = n, ... }
  end

  table.insert(self.subscribers[eventName], newSub)
end

function EventEmitter:rebroadcast(emitter, event)
  emitter:on(event, self.emit, self, event)
end

function EventEmitter:off(eventName, listener)
  if not self.subscribers then return end
  if not self.subscribers[eventName] then return end

  -- Find the sub this listener applies to.
  local subscriptions = self.subscribers[eventName]
  for i = 1, #subscriptions do
    local sub = subscriptions[i]
    if sub.listener == listener then
      table.remove(subscriptions, i)
      break
    end
  end
end

function EventEmitter:once(eventName, listener, ...)
  self:on(eventName, listener, ...)
  self:on(eventName, self.off, self, eventName, listener)
end

return EventEmitter
