local Player = require 'src.player'
local Card = require 'src.card'
local Combination = require 'src.combination'


local Model = {}


function Model:init(view)
  self.view = view

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

  self.timer = Timer.new()
end


function Model:update(dt)
  if self.timer then self.timer:update(dt) end
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


  -- Arrange all deck
  for i = 1, 4 do
    self.players[i]:arrange()
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
  if DEBUG then
    self.currentPlayerIndex = 1

    self.players[1].cards[1] = Card(Rank.THREE, Suit.SPADES)
    self.players[1].cards[2] = Card(Rank.THREE, Suit.CLUBS)
    self.players[1].cards[3] = Card(Rank.FOUR, Suit.SPADES)
    self.players[1].cards[4] = Card(Rank.FOUR, Suit.CLUBS)
    self.players[1].cards[5] = Card(Rank.FIVE, Suit.SPADES)
    self.players[1].cards[6] = Card(Rank.FIVE, Suit.CLUBS)
    self.players[1].cards[7] = Card(Rank.SIX, Suit.DIAMONDS)
    self.players[1].cards[8] = Card(Rank.SIX, Suit.HEARTS)
  end

  self.isFirstTurn = true

  self:nextPlayer()
end


function Model:nextPlayer()
  self.timer:after(1, function()
    self.players[self.currentPlayerIndex]:onTurn(self.currentCombination)
  end)
end


function Model:skip()
  self.players[1].skipped = true
  self:endCurrentTurn()
end


function Model:playSelectedCards()
  local cards = self:getSeletedCards()
  local combinationType = self:getCombinationTypeFromCards(cards)

  if (self.currentCombination == nil and combinationType ~= nil) or combinationType == self.currentCombination.type then
    if self.currentCombination == nil or (cards[#cards] > self.currentCombination.cards[#self.currentCombination.cards]) then
      self:setCurrentCombination(Combination(cards, combinationType))

      -- remove selected cards from player
      local i = 1
      while (i <= #self.players[1].cards) do
        if self.players[1].cards[i].selected then
          table.remove(self.players[1].cards, i)
        else
          i = i + 1
        end
      end

      self:endCurrentTurn()
    end
  end
end


function Model:getSeletedCards()
  local selectedCards = {}
  for i = 1, #self.players[1].cards do
    if self.players[1].cards[i].selected then
      table.insert(selectedCards, self.players[1].cards[i])
    end
  end
  return selectedCards
end


function Model:getCombinationTypeFromCards(cards)
  if #cards == 1 then
    return CombinationType.SINGLE

  elseif #cards == 2 then
    if cards[1].rank == cards[2].rank then
      return CombinationType.PAIR
    end

  elseif #cards == 3 then
    if cards[1].rank == cards[2].rank and cards[1].rank == cards[3].rank then
      return CombinationType.TRIPLET
    end

  elseif #cards == 4 then
    if cards[1].rank == cards[2].rank and cards[1].rank == cards[3].rank and cards[1].rank == cards[4].rank then
      return CombinationType.QUARTET
    end
  end

  if #cards >= 3 then
    local isSequence = true
    if cards[#cards].rank == Rank.TWO then isSequence = false end
    for i = 2, #cards do
      if cards[i].rank - cards[i-1].rank ~= 1 then
        isSequence = false
        break
      end
    end
    if isSequence then return CombinationType.SEQUENCE end
  end

  if #cards >= 6 and #cards % 2 == 0 then
    local isDouble, isSequence = true, true
    -- check DOUBLE
    for i = 1, #cards/2 do
      if cards[i*2].rank ~= cards[i*2-1].rank then
        isDouble = false
      end
    end
    -- check SEQUENCE
    for i = 2, #cards/2 do
      if cards[i*2].rank - cards[(i-1)*2].rank ~= 1 then
        isSequence = false
      end
    end
    if isDouble and isSequence then return CombinationType.DOUBLE_SEQUENCE end

  end

  return nil
end


function Model:endCurrentTurn()
  self.currentPlayerIndex = self.currentPlayerIndex + 1
  if self.currentPlayerIndex > 4 then
    self.currentPlayerIndex = 1
  end

  ---- This part can be written as a boolean expression
  -- local allSkippedExceptCurrentPlayer = true
  -- for i = 1, 4 do
  --   if i ~= self.currentPlayerIndex then
  --     if self.players[i].skipped == false then
  --       allSkippedExceptCurrentPlayer = false
  --       break
  --     end
  --   end
  -- end
  ---- !!
  ---- Oh here it is
  local players = self.players
  local allSkippedExceptCurrentPlayer =
      (players[1].skipped or self.currentPlayerIndex == 1) and
      (players[2].skipped or self.currentPlayerIndex == 2) and
      (players[3].skipped or self.currentPlayerIndex == 3) and
      (players[4].skipped or self.currentPlayerIndex == 4)
  ---- !!
  if allSkippedExceptCurrentPlayer then
    self:setCurrentCombination(nil)
  end

  self:nextPlayer()
end


function Model:playCombination(combination)
  local s = ''
  for i = 1, #combination.cards do
    s = s..string.format('%d-%d ', combination.cards[i].rank, combination.cards[i].suit)
  end
  print("I play "..s..'^w^')
  if self:getCombinationTypeFromCards(combination.cards) ~= nil then
    self:setCurrentCombination(combination)
  end
end


function Model:setCurrentCombination(combination)
  if self.currentCombination == nil then
    for i = 1, 4 do
      self.players[i].skipped = false
    end
  end
  self.currentCombination = combination
  self.view:onPlayerPlay(self.currentPlayerIndex)
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