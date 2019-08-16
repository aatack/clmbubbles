require "bubbles.bubble"

Variable = {}
Variable.__index = Variable
setmetatable(Variable, Bubble)

--- An abstract class which stores information about how a variable's value
-- changes as a function of time.  The `inputs` parameter should be a table of all variables
-- upon which this variable is dependent.  The `lambda` parameter
-- should be a function whose first argument is scalar for the time at which
-- the value is being calculated, and whose second argument is the inputs
-- dictionary.
function Variable:new(measuredtime)
  local variable = Bubble:new(measuredtime)
  setmetatable(variable, Variable)

  variable._value = nil

  return variable
end

--- Return the value of the variable at a particular moment in time.
function Variable:valuefunction(time)
  error("Variable:valuefunction has not been implemented")
end

--- Memoise and return the value of the variable at its measured time.
function Variable:value()
  if self._value == nil then
    self._value = self:valuefunction(self.measuredtime)
  end
  return self._value
end

--- Calculate and return the time at which this bubble's next
-- discontinuity occurs.  Return `math.huge` if there is no
-- foreseeable discontinuity.
function Variable:_time()
  error("Variable:_time has not been implemented")
end

--- Calculate and return the state of this bubble immediately
-- after the next discontinuity.  The `measuredtime` field of the
-- result should equal the `discontinuity.time` field of this bubble.
function Variable:_result()
  error("Variable:_result has not been implemented")
end

--- Assuming the given time is between the measured and discontinuity
-- times, return a new instance of this bubble where its values have
-- been extrapolated to the given time.
function Variable:_extrapolate(time)
  error("Variable:extrpolate has not been implemented")
end

--- Return a new bubble whose values are unchanged but whose
-- measured time has been shifted backwards by the given amount.
function Variable:rebase(delta)
  error("Variable:rebase has not been implemented")
end
