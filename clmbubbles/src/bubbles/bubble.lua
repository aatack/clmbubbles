Bubble = {}
Bubble.__index = Bubble

--- Base class from which any bubble should inherit.
function Bubble:new(measuredtime)
  local bubble = {}
  setmetatable(bubble, Bubble)

  bubble.measuredtime = measuredtime

  bubble.discontinuity.time = nil
  bubble.discontinuity.result = nil

  return bubble
end

--- Calculate and return the time at which this bubble's next
-- discontinuity occurs.  Return `math.huge` if there is no
-- foreseeable discontinuity.
function Bubble:_time()
  error("Bubble:_time has not been implemented")
end

--- Calculate and return the state of this bubble immediately
-- after the next discontinuity.  The `measuredtime` field of the
-- result should equal the `discontinuity.time` field of this bubble.
function Bubble:_result()
  error("Bubble:_result has not been implemented")
end

--- Assuming the given time is between the measured and discontinuity
-- times, return a new instance of this bubble where its values have
-- been extrapolated to the given time.
function Bubble:_extrapolate(time)
  error("Bubble:_extrapolate has not been implemented")
end

--- Return a new bubble whose values are unchanged but whose
-- measured time has been shifted backwards by the given amount.
function Bubble:rebase(delta)
  error("Bubble:rebase has not been implemented")
end

--- Get the time at which this bubble's next discontinuity occurs.
function Bubble:time()
  if self.discontinuity.time == nil then
    self.discontinuity.time = self:_time()
  end
  return self.discontinuity.time
end

--- Get the state of this bubble immediately after its next
-- discontinuity occurs.
function Bubble:result()
  if self.discontinuity.result == nil then
    self.discontinuity.result = self:_result()
  end
  return self.discontinuity.result
end

--- Return two values.  The second is a new instance of this
-- bubble whose fields have been propagated from its measured time
-- to the given time.  The first returned value is the bubble that
-- produced that result; normally, this will be the same as the
-- bubble the function is called on, but if a discontinuity is
-- crossed then a different bubble will be returned.  This
-- function has undefined behaviour if the passed time is less
-- than the bubble's measured time.
function Bubble:extrapolate(time)
  if time >= self:gettime() then
    return self:getresult():extrapolate(time)
  else
    return self, self:_extrapolate(time)
  end
end

--- Draw the bubble using the given transform to transfer points
-- from the global frame into the camera frame.
function Bubble:draw(transform)
  -- Does nothing by default
end
