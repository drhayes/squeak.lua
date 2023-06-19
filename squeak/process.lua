-- Shamelessly stolen from Deepnight
-- https://github.com/deepnight/deepnightLibs/blob/9d2b3d8bb54ad81be12e00b6c774df59aff70b61/src/dn/Process.hx
local Object = require('lib.classic')
local lume = require('lib.lume')

local Process = Object:extend()

function Process:new(parent)
  self.dead = false
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
  return self.enabled and not self.dead
end

function Process:pause()
  self.enabled = false
end

function Process:resume()
  self.enabled = true
end

function Process:togglePause()
  self.enabled = not self.enabled
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

function Process:die()
  self.dead = true
end

function Process.cleanup(processes)
  processes = processes or Process.roots
  local i = 1
  while i <= #processes do
    local p = processes[i]
    if p.dead then
      Process.dispose(p)
    else
      Process.cleanup(p.childProcesses)
      i = i + 1
    end
  end
end

function Process.dispose(process)
  local childProcesses = process.childProcesses
  for i = 1, #childProcesses do
    childProcesses[i]:die()
  end
  Process.cleanup(childProcesses)
  if process.parent ~= nil then
    lume.remove(process.parent.childProcesses, process)
  else
    lume.remove(Process.roots, process)
  end
  process.onDispose()
end

function Process:preUpdate(dt) end
function Process:update(dt) end
function Process:postUpdate(dt) end
function Process:onDispose() end

Process.roots = {}

return Process
