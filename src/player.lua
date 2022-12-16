local Card = require 'src.card'
local Combination = require 'src.combination'

local Player = Class('Player')


function Player:initialize(isAI)
  self.cards = {}
  self.skipped = false
  self.isAI = isAI or true
end


function Player:reset()
  self.cards = {}
  self.skipped = false
end


function Player:addCard(card)
  table.insert(self.cards, card)
end


function Player:arrange()
  table.sort(self.cards)
end


function Player:onTurn(currentCombination)
  -- local cards = {Card(Rank.THREE, Suit.SPADES)}
  -- currentCombination = Combination(cards, CombinationType.SINGLE)

  if self.isAI then
    print("It's my turn, the AI ^w^")

    if currentCombination.type == CombinationType.SINGLE and #self.cards >= 1 then
      local card
      for i = 1, #self.cards do
        if self.cards[i] > currentCombination.cards[1] then
          card = self.cards[i]
          break
        end
      end
      
      if card ~= nil then
        self:playCards({card}, CombinationType.SINGLE)
      else
        self:skip()
      end
  

    elseif currentCombination.type == CombinationType.PAIR and #self.cards >= 2 then
      local cards
      for i = 1, #self.cards-1 do
        if self.cards[i].rank == self.cards[i+1].rank then
          if self.cards[i+1] > currentCombination.cards[#currentCombination.cards] then
            cards = {
              self.cards[i],
              self.cards[i+1]
            }       
            break
          end
        end
      end

      if cards ~= nil then
        self:playCards(cards, CombinationType.PAIR)
      else
        self:skip()
      end

    elseif currentCombination.type == CombinationType.TRIPLET and #self.cards >= 3 then
      local cards
      for i = 1, #self.cards-2 do
        if self.cards[i].rank == self.cards[i+1].rank and self.cards[i].rank == self.cards[i+2].rank then
          if self.cards[i+2] > currentCombination.cards[#currentCombination.cards] then
            cards = {
              self.cards[i],
              self.cards[i+1],
              self.cards[i+2]
            }       
            break
          end
        end
      end

      if cards ~= nil then
        self:playCards(cards, CombinationType.TRIPLET)
      else
        self:skip()
      end

    elseif currentCombination.type == CombinationType.QUARTET and #self.cards >= 4 then
      local cards
      for i = 1, #self.cards-3 do
        if self.cards[i].rank == self.cards[i+1].rank and self.cards[i].rank == self.cards[i+2].rank
            and self.cards[i].rank == self.cards[i+3] then
          if self.cards[i+3] > currentCombination.cards[#currentCombination.cards] then
            cards = {
              self.cards[i],
              self.cards[i+1],
              self.cards[i+2],
              self.cards[i+3]
            }
            break
          end
        end
      end

      if cards ~= nil then
        self:playCards(cards, CombinationType.QUARTET)
      else
        self:skip()
      end

    elseif currentCombination.type == CombinationType.SEQUENCE then
      -- for i = 1, self.cards-#currentCombination.cards do
      --   for j
      -- end

    elseif currentCombination.type == CombinationType.DOUBLE_SEQUENCE then
    end
  end
end


function Player:playCards(cards, combinationType)
  -- remove selected cards from player
  local i, j = 1, 1
  while (j <= #cards) do
    if self.cards[i] == cards[j] then
      table.remove(self.cards, i)
      j = j + 1
    else
      i = i + 1
    end
  end
  Model:playCombination(Combination(cards, combinationType))
  Model:endCurrentTurn()
end


function Player:skip()
  self.skipped = true
  Model:endCurrentTurn()
end


return Player