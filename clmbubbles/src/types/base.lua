CLMBubble = {}
CLMBubble.__index = CLMBubble

--- Define the functions required for a continuous loss
-- minimised bubble to operate.
function CLMBubble:new(latvars)
  local clmbubble = {}
  setmetatable(clmbubble, CLMBubble)

  if type(latvars) ~= "table" then
    error("latent variables must be a table")
  end

  clmbubble.latvars = {
    value = latvars,
    loss = nil,
    slope = nil,
    curve = nil
  }

  return clmbubble
end

--- Apply the latent variables to the visible variables
-- of the bubble.
function CLMBubble:latapply()
  error("latapply not yet implemented")
end

--- Calculate the loss as a function of the current
-- latent variables.
function CLMBubble:loss(latvars)
  error("loss not yet implemented")
end

--- Calculate the first derivative of each of the latent
-- variables as a function of the current latent variables
-- and the loss resulting from them.
function CLMBubble:slope(latvars, latloss)
  error("slope not yet implemented")
end

--- Calculate the second derivative of each of the latent
-- variables as a function of their current values, the
-- resulting loss, and their first derivatives.
function CLMBubble:curve(latvers, latloss, latslope)
  error("curve not yet implemented")
end

--- In place, add each value from source to each value in
-- target.  Both can be assumed to have the same structure
-- as the bubble's latent variables.
function CLMBubble:latsum(target, source)
  error("latsum not yet implemented")
end

--- In place, multiply each value from the target by the
-- corresponding value in the source.  Both can be assumed
-- to have the same structure as the bubble's latent
-- variables.
function CLMBubble:latmul(target, source)
  error("latmul not yet implemented")
end

--- Make a deep copy of the given set of latent variables.
function CLMBubble:latcopy(source)
  error("latcopy not yet implemented")
end

--- Recalculate the values of the loss, slope, and curve
-- based on the current values of the latent variables.
function CLMBubble:recalculate()
  local latvars = self.latvars.value
  local latloss = self:loss(latvars)
  local latslope = self:slope(latvars, latloss)
  local latcurve = self:curve(latvars, latloss, latslope)
  self.latvars.loss = latloss
  self.latvars.slope = slope
  self.latvars.curve = curve
end
