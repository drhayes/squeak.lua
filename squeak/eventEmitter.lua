local Object = require 'lib.classic'

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

    -- If this subscription was removed this update cycle then
    -- don't call its listeners.
    if not sub.removeMe then
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

  for i = #subscriptions, 1, -1 do
    local sub = subscriptions[i]
    if sub.removeMe then
      table.remove(subscriptions, i)
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
    -- Is this the listener we're looking for?
    -- And it's not one that we're already removing?
    if sub.listener == listener and not sub.removeMe then
      sub.removeMe = true
      break
    end
  end
end

function EventEmitter:once(eventName, listener, ...)
  self:on(eventName, listener, ...)
  self:on(eventName, self.off, self, eventName, listener)
end

return EventEmitter
