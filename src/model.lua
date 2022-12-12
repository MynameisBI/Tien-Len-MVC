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
  self.players[1].isAI = false
  self.currentPlayerIndex = 1
  self.currentCombination = nil
  self.isFirstTurn = true
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


  -- Find player with 3 of spades
  local firstPlayerIndex
  for playerIndex = 1, 4 do 
    for i = 1, 13 do
      local card = self.players[playerIndex].cards[i]
      if card.rank == Rank.THREE and card.suit == Suit.SPADES then
        firstPlayerIndex = playerIndex
        goto done
      end
    end
  end
  ::done::

  -- Set all player except LP to 'skipped'
  for playerIndex = 1, 4 do
    if playerIndex ~= firstPlayerIndex then
      self.players[playerIndex].skipped = true
    end
  end

  -- Set current player as LP
  self.currentPlayerIndex = firstPlayerIndex


  self.isFirstTurn = true

  self:nextPlayer()
end


function Model:nextPlayer()
  self.players[self.currentPlayerIndex]:onTurn(self.currentCombination)
end


function Model:onPlayerTurnEnd()
  self.currentPlayerIndex = self.currentPlayerIndex + 1
  if self.currentPlayerIndex > 4 then
    self.currentPlayerIndex = 1
  end

  self:nextPlayer()
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