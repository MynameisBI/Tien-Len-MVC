require 'globals'

Model = require 'src.model'
View = require 'src.view'
Controller = require 'src.controller'


function love.load()
  Model:init()
  View:init(Model)
  Controller:init(Model, View)
end


function love.update(dt)
    View:update(dt)
end


function love.draw()
    View:draw()
end