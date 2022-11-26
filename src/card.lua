local Card = Class('Card')


function Card:initialize(rank, suit)
    self.rank = rank
    self.suit = suit
end


return Card