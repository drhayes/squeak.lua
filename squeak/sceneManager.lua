local Object = require 'lib.classic'
local PATH = (...):gsub('%.[^%.]+$', '')
local Stack = require(PATH .. '.stack')
-- Compatibility.
table.pack = table.pack or function(...) return { n = select("#", ...), ... } end
table.unpack = table.unpack or unpack


local SceneManager = Object:extend()

function SceneManager:new(eventBus)
  self.eventBus = eventBus
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

function SceneManager:current()
  return self.sceneStack:top()
end

function SceneManager:switch(newSceneName, ...)
  local newScene = self:get(newSceneName)
  if not newScene then return end

  self.nextSceneAction = 'switch'
  self.nextScene = newScene
  self.nextSceneArgs = table.pack(...)

  return newScene
end

function SceneManager:push(newSceneName, ...)
  -- We're still "in" prior scenes, don't leave them.
  local newScene = self:get(newSceneName)
  if not newScene then return end

  self.nextSceneAction = 'push'
  self.nextScene = newScene
  self.nextSceneArgs = table.pack(...)

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
end

-- Doing all the scene switching after draw to prevent a frame
-- of black, uninitialized scene-stuff getting drawn after a switch
-- in update.
function SceneManager:draw()
  local current = self.sceneStack:top()
  if current then
    current:draw()
  end

  -- Now the current scene is drawn, check to see if we're switching.
  if self.nextSceneAction == 'switch' then
    self.nextSceneAction = nil
    -- Leave all our current scenes.
    local scratchScene = self.sceneStack:pop()
    while scratchScene ~= nil do
      scratchScene:leave()
      scratchScene = self.sceneStack:pop()
    end

    -- This scene is the current. Enter it.
    self.sceneStack:push(self.nextScene)
    self.eventBus:emit('beforeSceneChange', self.nextScene)
    self.nextScene:enter(table.unpack(self.nextSceneArgs, 1, self.nextSceneArgs.n))

  elseif self.nextSceneAction == 'push' then
    self.nextSceneAction = nil
    self.sceneStack:push(self.nextScene)
    self.eventBus:emit('beforeSceneChange', self.nextScene)
    self.nextScene:enter(table.unpack(self.nextSceneArgs, 1, self.nextSceneArgs.n))

  elseif self.nextSceneAction == 'pop' then
    self.nextSceneAction = nil
    local oldScene = self.sceneStack:pop()
    if not oldScene then
      log.error('Tried to pop a non-existent scene!')
      return
    end

    oldScene:leave()

    -- Current scene needs to be setActive.
    current = self.sceneStack:top()
    if current == nil then
      log.error('No scene on stack!')
      error('No scene on stack!')
    end

    self.eventBus:emit('beforeSceneChange', current)
    current:restore()
  end
end

function SceneManager:resize(w, h)
  local current = self.sceneStack:top()
  if current then
    current:resize(w, h)
  end
end

function SceneManager:keypressed(key, scancode, isRepeat)
  local current = self.sceneStack:top()
  if current then
    current:keypressed(key, scancode, isRepeat)
  end
end

function SceneManager:keyreleased(key, scancode)
  local current = self.sceneStack:top()
  if current then
    current:keyreleased(key, scancode)
  end
end

function SceneManager:gamepadpressed(joystick, button)
  local current = self.sceneStack:top()
  if current then
    current:gamepadpressed(joystick, button)
  end
end


function SceneManager:gamepadreleased(joystick, button)
  local current = self.sceneStack:top()
  if current then
    current:gamepadreleased(joystick, button)
  end
end

function SceneManager:mousemoved(x, y, dx, dy, istouch)
  local current = self.sceneStack:top()
  if current then
    current:mousemoved(x, y, dx, dy, istouch)
  end
end

function SceneManager:mousepressed(x, y, button, istouch)
  local current = self.sceneStack:top()
  if current then
    current:mousepressed(x, y, button, istouch)
  end
end

function SceneManager:mousereleased(x, y, button, istouch)
  local current = self.sceneStack:top()
  if current then
    current:mousereleased(x, y, button, istouch)
  end
end

function SceneManager:inScene(sceneName)
  local currentScene = self:current()
  local thatScene = self:get(sceneName)
  return currentScene == thatScene
end

return SceneManager
