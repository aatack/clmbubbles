require "bubbles.bubble"

Variable = {}
Variable.__index = Variable
setmetatable(Variable, Bubble)

--- An abstract class which stores information about how a variable's value
-- changes as a function of time, as well as (optionally) similar data for its
-- derivatives.  The `inputs` parameter should be a table of all variables
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
