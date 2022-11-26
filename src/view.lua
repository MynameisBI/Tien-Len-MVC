local Suit = require 'libs.suit'


local View = {}


local cardWidth, cardHeight = 50, 80
local cardSpaceRatio = -0.35

local upperX, upperY = love.graphics.getWidth()/2 - cardWidth/2, 40
local leftX, leftY = 75, love.graphics.getHeight()/2 - cardHeight/2
local rightX, rightY = 675, love.graphics.getHeight()/2 - cardHeight/2
local lowerX, lowerY =  love.graphics.getWidth()/2 - 125, 460


function View:init(model, controller)
  self.model = model
  self.controller = controller
  
  self.suit = Suit.new()
end


function View:update(dt)
  -- Skip button
  if self.suit:Button('skip', 620, 510, 80, 40).hit then

  end

  -- Play button
  if self.suit:Button('play', 620, 450, 80, 40).hit then

  end

  -- Lower cards
  local humanCards = self.model:getHumanCards()
  for i = 1, #humanCards do
    local x = lowerX + (-#humanCards/2 + i) * cardWidth + (-(#humanCards+1)/2 + i) * cardWidth * cardSpaceRatio
    local y = humanCards[i].selected and lowerY - 25 or lowerY

    if self.suit:Button(string.format('%d-%d', humanCards[i].suit, humanCards[i].rank),
        x, y, cardWidth, cardHeight).hit then
      self.controller:onCardSelected(i)
    end
  end
end


function View:draw()
  self.suit:draw()

  -- Upper cards
  -- love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle('line', upperX, upperY, cardWidth, cardHeight)
  love.graphics.print(tostring(self.model:getAICardsNum(AIID.UPPER)), upperX + 17, upperY + 32)

  -- Left cards
  love.graphics.rectangle('line', leftX, leftY, cardWidth, cardHeight)
  love.graphics.print(tostring(self.model:getAICardsNum(AIID.LEFT)), leftX + 17, leftY + 32)

  -- Right cards
  love.graphics.rectangle('line', rightX, rightY, cardWidth, cardHeight)
  love.graphics.print(tostring(self.model:getAICardsNum(AIID.RIGHT)), rightX + 17, rightY + 32)
  
end


return View