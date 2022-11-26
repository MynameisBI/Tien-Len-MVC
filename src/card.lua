local Card = Class('Card')


function Card:initialize(rank, suit)
    self.rank = rank
    self.suit = suit
    
    self.selected = false
end


return Card