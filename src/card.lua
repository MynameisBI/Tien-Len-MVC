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

function Card:__le(other)
  if self.rank < other.rank then
    return true
  elseif self.rank > other.rank then
    return false
  else
    if self.suit <= other.suit then
      return true
    else
      return false
    end
  end
end

function Card:__eq(other)
  if self.rank == other.rank and self.suit == other.suit then
    return true
  end
  return false
end

return Card