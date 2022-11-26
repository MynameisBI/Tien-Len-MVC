local Controller = {}


function Controller:init(model, view)
  self.model = model
  self.view = view
  self.isAnimating = false
end


function Controller:humanSkipped()

end


function Controller:humanPlayed(combination)

end


function Controller:AISkipped()

end


function Controller:AIPlayed(combination)

end


return Controller