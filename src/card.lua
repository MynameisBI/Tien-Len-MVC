local Card = Class('Card')


function Card:initialize(rank, suit)
  self.rank = rank
  self.suit = suit
  
  self.selected = false
end


function Card:__lt(other)
  if self.rank < other.rank then
    return true
  elseif self.rank > other.rank then
    return false
  else
    if self.suit < other.suit then
      return true
    else
      return false
    end
  end
end


return Card