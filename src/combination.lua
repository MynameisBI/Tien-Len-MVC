local Combination = Class('Combination')


function Combination:initialize(cards, combinationType)
    self.cards = cards
    self.type = combinationType
end


return Combination