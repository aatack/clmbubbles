require "bubbles.numeric.independent"

LinearApproximation = {}
LinearApproximation.__index = LinearApproximation
setmetatable(LinearApproximation, Independent)

--- Linearly approximate a time-varying bubble, declaring that the
-- approximation is accurare until the difference between the linear
-- approximation and a quadratic approximation has reached the stated
-- error limit.
function LinearApproximation:new(source, time, errorlimit)
  error("LinearApproximation:new is not yet fully implemented")

  local linearapproximation = Independent:new(time, value, slope, curve, limit)
  setmetatable(linearapproximation, LinearApproximation)

  return linearapproximation
end
