local Player = require 'src.player'
local Card = require 'src.card'

local Model = {}


function Model:init()
  self.players = {}
  for i = 1, 4 do
    local player = Player()
    table.insert(self.players, player)
  end
  self.currentPlayerIndex = 1
  self.currentCombination = nil
end


function Model:getCurrentCombination()
  return self.currentCombination
end


return Model