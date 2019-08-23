Bubble = {}
Bubble.__index = Bubble

--- Base class from which any bubble should inherit.
function Bubble:new(measuredtime, measuredvariables)
  local bubble = {}
  setmetatable(bubble, Bubble)

  bubble.measuredtime = measuredtime
  bubble.measuredvariables = measuredvariables
  bubble.time = bubble.measuredtime

  return bubble
end

--- Set the values of the bubble's variables to their values
-- at the given time.
function Bubble:settime(time)
  error("Bubble:settime has not been implemented")
end

--- Draw the bubble at the current time, through the perspective of
-- the given camera.
function Bubble:draw(camera)
  error("Bubble:draw has not been implemented")
end
