local PATH = (...):gsub('%.init$', '')

local Squeak = {
  _VERSION     = '2.0.0',
  _DESCRIPTION = 'A small, opinionated game framework.',
  _LICENCE     = [[
      MIT LICENSE
      Copyright (c) 2020-2023 David R. Hayes

      Permission is hereby granted, free of charge, to any person obtaining a
      copy of this software and associated documentation files (the
      "Software"), to deal in the Software without restriction, including
      without limitation the rights to use, copy, modify, merge, publish,
      distribute, sublicense, and/or sell copies of the Software, and to
      permit persons to whom the Software is furnished to do so, subject to
      the following conditions:
      The above copyright notice and this permission notice shall be included
      in all copies or substantial portions of the Software.
      THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
      OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
      MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
      IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
      CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
      TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
      SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
   ]]
}

Squeak.component = require(PATH .. '.component')
Squeak.components = require(PATH .. '.components')
Squeak.coroutineList = require(PATH .. '.coroutineList')
Squeak.eventEmitter = require(PATH .. '.eventEmitter')
Squeak.gameObject = require(PATH .. '.gameObject')
Squeak.gobsList = require(PATH .. '.gobsList')
Squeak.registry = require(PATH .. '.registry')
Squeak.scene = require(PATH .. '.scene')
Squeak.sceneManager = require(PATH .. '.sceneManager')
Squeak.stack = require(PATH .. '.stack')

return Squeak
