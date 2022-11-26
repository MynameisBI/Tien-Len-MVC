local Player = Class('Player')


function Player:initialize()
    self.cards = {}
    self.skipped = false
end


function Player:reset()
    self.cards = {}
    self.skipped = false
end


function Player:addCard(card)
    table.insert(self.cards, card)
end


function Player:getBestCombination(combinationType)

end


return Player