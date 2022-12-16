local Controller = {}


function Controller:init(model, view)
  self.model = model
  self.view = view
  self.isAnimating = false
end


function Controller:onCardSelected(cardIndex)
  local card = self.model:getHumanCards()[cardIndex]
  card.selected = not card.selected
end


function Controller:skip()
  self.model:skip()
end


function Controller:playSelectedCards()
  self.model:playSelectedCards()
end


return Controller