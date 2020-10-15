local Object = require 'classic'
local lume = require 'lume'

local GobsList = Object:extend()

function GobsList:new(eventBus, gobCompare)
  self.eventBus = eventBus
  self.gobCompare = gobCompare
  self.gobs = {}
  self.additions = {}
  self.removals = {}
end

function GobsList:update(dt)
  local gobs = self.gobs

  -- Update'em.
  for i = 1, #gobs do
    local gob = gobs[i]
    gob:update(dt)
    if gob.removeMe then
      self:remove(gob)
    end
  end

  -- Process additions.
  local additions = self.additions
  for i = 1, #additions do
    local gob = additions[i]
    table.insert(self.gobs, gob)
    gob:gobAdded()
    self.eventBus:emit('gobAdded', gob)
  end
  if #additions > 0 then
    if self.gobCompare then
      table.sort(self.gobs, self.gobCompare)
    end
    lume.clear(self.additions)
  end

  -- Process removals.
  local removals = self.removals
  for i = 1, #removals do
    local gob = removals[i]
    lume.remove(self.gobs, gob)
    gob:gobRemoved()
    self.eventBus:emit('gobRemoved', gob)
  end
  if #removals > 0 then
    lume.clear(self.removals)
  end
end

function GobsList:draw()
  for i = 1, #self.gobs do
    local gob = self.gobs[i]
    gob:draw()
  end
end

function GobsList:add(gob)
  table.insert(self.additions, gob)
end

function GobsList:remove(gob)
  table.insert(self.removals, gob)
end

function GobsList:clear()
  for i = 1, #self.gobs do
    local gob = self.gobs[i]
    gob:gobRemoved()
  end
  lume.clear(self.gobs)
  self.eventBus:emit('gobsCleared')
end

function GobsList:findFirst(gobType)
  for i = 1, #self.gobs do
    local gob = self.gobs[i]
    if gob:is(gobType) then
      return gob
    end
  end
end

return GobsList
