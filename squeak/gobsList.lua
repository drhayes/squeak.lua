local Object = require 'lib.classic'
local PATH = (...):gsub('%.[^%.]+$', '')
local EventEmitter = require(PATH .. '.eventEmitter')
local lume = require 'lib.lume'


local GobsList = Object:extend()

function GobsList:new(gobCompare)
  self.gobCompare = gobCompare
  self.events = EventEmitter()
  self.gobs = {}
  self.gobsById = {}
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
  self.additions = {}
  for i = 1, #additions do
    local gob = additions[i]
    table.insert(self.gobs, gob)
    if gob.id then
      self.gobsById[gob.id] = gob
    end
    gob.parent = self
  end
  if #additions > 0 then
    -- Sort the new additions.
    if self.gobCompare then
      table.sort(self.gobs, self.gobCompare)
    end

    -- Run the new additions gobAdded events, all at once.
    for i = 1, #additions do
      local gob = additions[i]
      gob:gobAdded()
      self.events:emit('gobAdded', gob)
    end
  end

  -- Process removals.
  local removals = self.removals
  self.removals = {}
  for i = 1, #removals do
    local gob = removals[i]
    lume.remove(self.gobs, gob)
    if gob.id then
      self.gobsById[gob.id] = nil
    end
  end
  if #removals > 0 then
    -- Run the removals all at once.
    for i = 1, #removals do
      local gob = removals[i]
      gob.parent = nil
      gob:gobRemoved()
      self.events:emit('gobRemoved', gob)
    end
  end
end

function GobsList:draw(filterIn, filterOut)
  for i = 1, #self.gobs do
    local gob = self.gobs[i]
    if filterIn and gob.layer == filterIn then
      gob:draw()
    elseif filterOut and gob.layer ~= filterOut then
      gob:draw()
    elseif not filterIn and not filterOut then
      gob:draw()
    end
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
  lume.clear(self.gobsById)
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

function GobsList:byId(id)
  local gob = self.gobsById[id]
  if not gob then
    log.warn('no gob found by that id', id)
  end
  return gob
end

function GobsList:query(pred, matchedGobs)
  matchedGobs = matchedGobs or {}
  for i = 1, #self.gobs do
    local gob = self.gobs[i]
    if pred(gob) then
      table.insert(matchedGobs, gob)
    end
  end
  return matchedGobs
end

function GobsList:queryByComponent(componentType, fn)
  for i = 1, #self.gobs do
    local gob = self.gobs[i]
    if gob:findFirst(componentType) then
      -- Return true to early exit.
      local result = fn(gob)
      if result == true then
        return
      end
    end
  end
end

function GobsList:on(...)
  self.events:on(...)
end

function GobsList:off(...)
  self.events:off(...)
end

function GobsList:__tostring()
  return 'GobsList'
end

return GobsList
