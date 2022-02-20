local Object = require 'lib.classic'
local PATH = (...):gsub('%.[^%.]+$', '')
local EventEmitter = require(PATH .. '.eventEmitter')
local lume = require 'lib.lume'


local GobsList = Object:extend()

function GobsList:new(gobCompare)
  self.gobCompare = gobCompare
  self.events = EventEmitter()
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
    self.events:emit('gobAdded', gob)
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
    self.events:emit('gobRemoved', gob)
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
  return gob
end

function GobsList:remove(gob)
  table.insert(self.removals, gob)
  return gob
end

function GobsList:clear()
  for i = 1, #self.gobs do
    local gob = self.gobs[i]
    gob:gobRemoved()
  end
  lume.clear(self.gobs)
  self.events:emit('gobsCleared')
end

function GobsList:findFirst(gobType)
  for i = 1, #self.gobs do
    local gob = self.gobs[i]
    if gob:is(gobType) then
      return gob
    end
  end
end

function GobsList:gobAtPos(x, y)
  for i = 1, #self.gobs do
    local gob = self.gobs[i]
    -- Only do this for GameObjects that have widths and heights.
    if gob.width and gob.height then
      local left, top = gob.x, gob.y
      local right, bottom = gob.x + gob.width, gob.y + gob.height
      if x >= left and x <= right and y >= top and y <= bottom then
        return gob
      end
    end
  end
end

function GobsList:on(...)
  self.events:on(...)
end

return GobsList
