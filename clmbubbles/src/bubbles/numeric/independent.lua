require "bubbles.bubble"

Independent = {}
Independent.__index = Independent
setmetatable(Independent, Bubble)

--- Describe an independent variable as a function of time alone.
function Independent:new(measuredtime, value, slope, curve, upperbound)
  local independent = Bubble:new(measuredtime)
  setmetatable(independent, Independent)

  independent.functions = {}
  independent.functions.value = value
  if slope ~= nil then
    independent.functions.slope = slope
  else
    independent.functions.slope = derivative(independent.functions.value)
  end
  if curve ~= nil then
    independent.functions.curve = curve
  else
    independent.functions.curve = derivative(independent.functions.slope)
  end

  independent.upperbound = upperbound or math.huge

  independent.values = {}
  independent:calculatevalues()

  return independent
end

--- Calculate the values of the value, slope, and curve of the variable.
function Independent:calculatevalues()
  local values = self.values
  local functions = self.functions
  local time = self.measuredtime

  values.value = functions.value(time)
  values.slope = functions.slope(time)
  values.curve = functions.curve(time)
end

--- Calculate and return the time at which this bubble's next
-- discontinuity occurs.  Return `math.huge` if there is no
-- foreseeable discontinuity.
function Independent:_time()
  return self.upperbound
end

--- Calculate and return the state of this bubble immediately
-- after the next discontinuity.  The `measuredtime` field of the
-- result should equal the `discontinuity.time` field of this bubble.
function Independent:_result()
  return nil
end

--- Assuming the given time is between the measured and discontinuity
-- times, return a new instance of this bubble where its values have
-- been extrapolated to the given time.
function Independent:_extrapolate(time)
  local functions = self.functions
  return Independent:new(
    time, functions.value, functions.slope, functions.curve, self.upperbound
  )
end

--- Return a new bubble whose values are unchanged but whose
-- measured time has been shifted backwards by the given amount.
function Independent:rebase(delta)
  local rebase = function(f)
    return function(t) return f(t - delta) end end
  end
  local functions = self.functions

  return Independent:new(
    self.measuredtime - delta,
    rebase(functions.value),
    rebase(functions.slope),
    rebase(functions.curve),
    self.upperbound - delta
  )
end
