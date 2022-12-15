require 'globals'
require 'assets'

Model = require 'src.model'
View = require 'src.view'
Controller = require 'src.controller'


--[[ TODO
  - organize hand
  - play first combinations
    + check if selected cards valid -> then play
    + set currentCombinations and next player
  - AI play
]]--


function love.load()
  math.randomseed(os.time())
  -- math.randomseed(69)

  Model:init()
  View:init(Model, Controller)
  Controller:init(Model, View)

  Model:startGame()
end


function love.update(dt)
  View:update(dt)
end


function love.draw()
  View:draw()

  if DEBUG then
    love.graphics.print('DEBUG = True')
  end
end