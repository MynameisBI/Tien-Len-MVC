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
  if self.isAI then
    self:playCards()
    Model:onPlayerTurnEnd()
  end
end

function Player:getBestCombination(combinationType)
  if self.isAI then
    self.cards = {}
    if self.currentCombination == true then
      self:playCards()
      Model:onPlayerTurnEnd()
    end
  end 

end


function Player:playCards()
  print('play cards')
end


function Player:skipCards()
  if self.isAI then
    self.cards = {}
    if self.currentCombination == true then
      self.skipped = true
      Model:onPlayerTurnEnd()
    end
  end
end


return Player