local Player = require 'src.player'
local Card = require 'src.card'

local Model = {}


function Model:init()
  self.deck = {}
  for suit, sValue in pairs(Suit) do
    for rank, rValue in pairs(Rank) do
      local card = Card(rValue, sValue)
      table.insert(self.deck, card)
    end
  end

  self.players = {}
  for i = 1, 4 do
    local player = Player()
    table.insert(self.players, player)
  end
  self.currentPlayerIndex = 1
  self.currentCombination = nil
end


function Model:startGame()
  for i = 1, 4 do
    self.players[i]:reset()
  end


  -- Deal cards
  local cardIndexes = {}
  for i = 1, 52 do
    cardIndexes[i] = i
  end

  local splitedcardIndexes = {}
  for deck = 1, 4 do
    splitedcardIndexes[deck] = {}

    for i = 1, 13 do
      local randomIndex = math.random(1, #cardIndexes)
      splitedcardIndexes[deck][i] = cardIndexes[randomIndex]
      table.remove(cardIndexes, randomIndex)
    end
  end

  -- Can combine this with the upper loop
  -- But kept for readability
  for deck = 1, 4 do 
    for i = 1, 13 do
      local cardIndex = splitedcardIndexes[deck][i]
      self.players[deck]:addCard(self.deck[cardIndex])
    end
  end
end


function Model:getHumanCards()
  return self.players[1].cards
end


function Model:getAICardsNum(aiID)
  if aiID == AIID.UPPER then
    return #self.players[3].cards
  elseif aiID == AIID.LEFT then
    return #self.players[4].cards
  elseif aiID == AIID.RIGHT then
    return #self.players[2].cards
  end
end


function Model:getCurrentCombination()
  return self.currentCombination
end


return Model