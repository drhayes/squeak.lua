local Object = require 'classic'
local PATH = (...):gsub('%.[^%.]+$', '')
local Stack = require(PATH .. '.stack')

local SceneManager = Object:extend()

function SceneManager:new()
  self.scenes = {}
  self.sceneStack = Stack()
  -- This is one of 'push', 'pop', or 'switch'.
  self.nextSceneAction = nil
  self.nextScene = nil
  self.nextSceneArgs = nil
end

function SceneManager:add(name, scene)
  self.scenes[name] = scene
  scene.parent = self
  return scene
end

function SceneManager:get(name)
  local scene = self.scenes[name]
  if not scene then
    log.error('tried to get nonexistent scene', name)
  end
  return scene
end

function SceneManager:switch(newSceneName, ...)
  local newScene = self:get(newSceneName)
  if not newScene then return end

  self.nextSceneAction = 'switch'
  self.nextScene = newScene
  self.nextSceneArgs = { ... }

  return newScene
end

function SceneManager:push(newSceneName, ...)
  -- We're still "in" prior scenes, don't leave them.
  local newScene = self:get(newSceneName)
  if not newScene then return end

  self.nextSceneAction = 'push'
  self.nextScene = newScene
  self.nextSceneArgs = { ... }

end

function SceneManager:pop()
  -- Leave whatever scene we're in.
  self.nextSceneAction = 'pop'
end

function SceneManager:update(dt)
  local current = self.sceneStack:top()
  if current then
    current:update(dt)
  end
  if self.nextSceneAction == 'switch' then
    self.nextSceneAction = nil
    -- Leave all our current scenes.
    local scratchScene = self.sceneStack:pop()
    while scratchScene ~= nil do
      scratchScene:leave()
      scratchScene = self.sceneStack:top()
    end

    -- This scene is the current. Enter it.
    self.sceneStack:push(self.nextScene)
    self.nextScene:enter(unpack(self.nextSceneArgs))
  elseif self.nextSceneAction == 'push' then
    self.nextSceneAction = nil
    self.sceneStack:push(self.nextScene)
    self.nextScene:enter(unpack(self.nextSceneArgs))
  elseif self.nextSceneAction == 'pop' then
    self.nextSceneAction = nil
    local oldScene = self.sceneStack:pop()
    if not oldScene then
      log.error('Tried to pop a non-existent scene!')
      return
    end

    oldScene:leave()

    -- Whatever our current is needs to be setActive.
    current = self.sceneStack:top()
    if current == nil then
      log.error('No scene on stack!')
      error('No scene on stack!')
    end

    current:restore()
  end
end

function SceneManager:draw()
  local current = self.sceneStack:top()
  if current then current:draw() end
end

return SceneManager
