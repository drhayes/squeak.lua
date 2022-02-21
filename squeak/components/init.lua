local PATH = (...):gsub('%.init$', '')

local components = {
  cooldowns = require(PATH .. '.cooldowns'),
  coroutine = require(PATH .. '.coroutine'),
  follow = require(PATH .. '.follow'),
  interval = require(PATH .. '.interval'),
  particles = require(PATH .. '.particles'),
  throttledFunction = require(PATH .. '.throttledFunction'),
  timer = require(PATH .. '.timer'),
}

return components

