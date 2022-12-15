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
  local cards = {Card(Rank.THREE, Suit.SPADES)}
  currentCombination = Combination(cards, CombinationType.SINGLE)

  if self.isAI then
    print("It's my turn, the AI ^w^")
    Model:endCurrentTurn()

    -- if currentCombination.type == CombinationType.SINGLE then
    --   local card
    --   for i = 1, #self.cards do
    --     if self.cards[i] > currentCombination.cards[1] then
    --       card = self.cards[i]
    --       break
    --     end
    --   end
      
    --   if card ~= nil then
    --     self.playCards(card)
    --   else
    --     self:skip()
    --   end
  

    -- elseif currentCombination.type == CombinationType.PAIR then
    --   local card1, card2
    

    -- elseif currentCombination.type == CombinationType.TRIPLET then
    

    -- elseif currentCombination.type == CombinationType.QUARTET then
    

    -- elseif currentCombination.type == CombinationType.SEQUENCE then
    

    -- elseif currentCombination.type == CombinationType.DOUBLE_SEQUENCE then
    -- end
  end
end

function Player:getBestCombination(combination)

end


function Player:playCards()
  print('play cards')
end


function Player:skip()
  if self.isAI then
    self.cards = {}
    if self.currentCombination == nil then
      self.skipped = true
      Model:endCurrentTurn()
    end
  end
end


return Player