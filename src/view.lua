local Suit = require 'libs.suit'


local View = {}


local cardWidth, cardHeight = 50, 80
local cardSpaceRatio = -0.35

local upperX, upperY = love.graphics.getWidth()/2 - cardWidth/2, 40
local leftX, leftY = 75, love.graphics.getHeight()/2 - cardHeight/2
local rightX, rightY = 675, love.graphics.getHeight()/2 - cardHeight/2
local lowerX, lowerY =  love.graphics.getWidth()/2 - 125, 460


function View:init(model)
  self.model = model
  
  self.suit = Suit.new()

  self.upperCardsNum = 13
  self.leftCardsNum = 13
  self.rightCardsNum = 13
  self.lowerCards = {}
end


function View:update(dt)
  -- Skip button
  if self.suit:Button('skip', 620, 510, 80, 40).hit then

  end

  -- Play button
  if self.suit:Button('play', 620, 450, 80, 40).hit then

  end

  -- Lower cards
  for i = 1, self.upperCardsNum do
    local x = lowerX + (-self.upperCardsNum/2 + i) * cardWidth + (-(self.upperCardsNum+1)/2 + i) * cardWidth * cardSpaceRatio
    if self.suit:Button(tostring(i), x, lowerY, cardWidth, cardHeight).hit then

    end
  end
end


function View:draw()
  self.suit:draw()

  -- Upper cards
  -- love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle('line', upperX, upperY, cardWidth, cardHeight)
  love.graphics.print(tostring(self.upperCardsNum), upperX + 17, upperY + 32)

  -- Left cards
  love.graphics.rectangle('line', leftX, leftY, cardWidth, cardHeight)
  love.graphics.print(tostring(self.upperCardsNum), leftX + 17, leftY + 32)

  -- Right cards
  love.graphics.rectangle('line', rightX, rightY, cardWidth, cardHeight)
  love.graphics.print(tostring(self.upperCardsNum), rightX + 17, rightY + 32)
  
end


return View