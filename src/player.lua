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
    if currentCombination == nil and #self.cards >= 1 then
      -- Check sequence
      local sequence = {self.cards[1]}
      for j = 2, #self.cards do
        if self.cards[j].rank - sequence[#sequence].rank == 1 then
          table.insert(sequence, self.cards[j])
        elseif self.cards[j].rank - sequence[#sequence].rank >= 2 then
          break
        end
      end
      if #sequence >= 3 then
        self:playCards(sequence, CombinationType.SEQUENCE)
        return
      end

      -- Check quartet
      if #self.cards >= 4 then
        if self.cards[1].rank == self.cards[2].rank and self.cards[1].rank == self.cards[3].rank and
            self.cards[1].rank == self.cards[4] then
          local quartet = {self.cards[1], self.cards[2], self.cards[3], self.cards[4]}
          self:playCards(quartet, CombinationType.QUARTET)
          return
        end
      end

      -- Check triplet
      if #self.cards >= 3 then
        if self.cards[1].rank == self.cards[2].rank and self.cards[1].rank == self.cards[3].rank then
          local triplet = {self.cards[1], self.cards[2], self.cards[3]}
          self:playCards(triplet, CombinationType.TRIPLET)
          return
        end
      end

      -- Check pair
      if #self.cards >= 2 then
        if self.cards[1].rank == self.cards[2].rank then
          local pair = {self.cards[1], self.cards[2]}
          self:playCards(pair, CombinationType.PAIR)
          return
        end
      end

      -- Check single
      self:playCards({self.cards[1]}, CombinationType.SINGLE)
      

    elseif currentCombination.type == CombinationType.SINGLE and #self.cards >= 1 then
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
      local cards
      for i = 1, #self.cards - #currentCombination.cards do
        local comb = {self.cards[i]}
        for j = i+1, #self.cards - #currentCombination.cards + #comb do
          if self.cards[j].rank ~= 13 and self.cards[j].rank - comb[#comb].rank == 1 then
            table.insert(comb, self.cards[j])
            if #comb == #currentCombination.cards then
              if comb[#comb] > currentCombination.cards[#currentCombination.cards] then
                cards = comb
                goto break2
              end
            end
          end
        end
      end
      ::break2::

      if cards ~= nil then
        self:playCards(cards, CombinationType.SEQUENCE)
      else
        self:skip()
      end

    elseif currentCombination.type == CombinationType.DOUBLE_SEQUENCE then
      local cards
      for i = 1, #self.cards - #currentCombination.cards do
        local comb = {self.cards[i]}
        for j = i+1, #self.cards - #currentCombination.cards + #comb do
          if self.cards[j].rank ~= 13 and self.cards[j].rank - comb[#comb].rank == 1 then
            table.insert(comb, self.cards[j])
            if #comb == #currentCombination.cards then
              if comb[#comb] > currentCombination.cards[#currentCombination.cards] then
                cards = comb
                goto break2
              end
            end
          end
        end
      end
      ::break2::

      if cards ~= nil then
        self:playCards(cards, CombinationType.SEQUENCE)
      else
        self:skip()
      end
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