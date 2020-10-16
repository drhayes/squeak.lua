local Object = require 'lib.classic'

local SceneManager = Object:extend()

function SceneManager:new(camera)
  self.scenes = {}
  self.current = nil
  self.camera = camera
end

function SceneManager:add(name, scene)
  self.scenes[name] = scene
  scene.parent = self
  scene.camera = self.camera
  return scene
end

function SceneManager:get(name)
  local scene = self.scenes[name]
  if not scene then
    log.warn('tried to get nonexistent scene', name)
  end
  return scene
end

function SceneManager:switch(newSceneName)
  local newScene = self.scenes[newSceneName]
  if not newScene then
    log.error('Bad scene name', newSceneName)
    return
  end

  if self.current then
    self.current:leave()
  end
  self.current = newScene
  self.current:enter()

  return self.current
end

function SceneManager:update(dt)
  self.current:update(dt)
end

function SceneManager:draw()
  self.current:draw()
end

return SceneManager
