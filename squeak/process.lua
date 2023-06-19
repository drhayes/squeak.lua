local Object = require('lib.classic')
local lume = require('lib.lume')

local Process = Object:extend()

function Process:new(parent)
  self.childProcesses = {}
  self.parent = nil
  self.enabled = true
  if parent then
    parent:attach(self)
  elseif not self.parent then
    table.insert(Process.roots, self)
  end
end

function Process:attach(child)
  if child.parent == nil then
    lume.remove(Process.roots, child)
  else
    lume.remove(child.parent.childProcesses, child)
  end
  child.parent = self
  table.insert(self.childProcesses, child)
end

function Process:detach(child)
  if child.parent ~= self then
    log.error('Trying to detach a child process that is not attached to this process: ' .. child)
    return
  end
  lume.remove(self.childProcesses, child)
  child.parent = nil
  table.insert(Process.roots, child)
end

function Process:canRun()
  return self.enabled
end

function Process.runPreUpdate(p, dt)
  if not p:canRun() then return end
  p:preUpdate(dt)
  if not p:canRun() then return end
  local childProcesses = p.childProcesses
  for i = 1, #childProcesses do
    local childProcess = childProcesses[i]
    Process.runPreUpdate(childProcess, dt)
  end
end

function Process.runUpdate(p, dt)
  if not p:canRun() then return end
  p:update(dt)
  if not p:canRun() then return end
  local childProcesses = p.childProcesses
  for i = 1, #childProcesses do
    local childProcess = childProcesses[i]
    Process.runUpdate(childProcess, dt)
  end
end

function Process.runPostUpdate(p, dt)
  if not p:canRun() then return end
  p:postUpdate(dt)
  if not p:canRun() then return end
  local childProcesses = p.childProcesses
  for i = 1, #childProcesses do
    local childProcess = childProcesses[i]
    Process.runPostUpdate(childProcess, dt)
  end
end

function Process:preUpdate(dt) end
function Process:update(dt) end
function Process:postUpdate(dt) end

Process.roots = {}

return Process
