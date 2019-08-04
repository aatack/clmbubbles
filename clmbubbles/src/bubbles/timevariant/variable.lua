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
function Variable:new(measuredtime, lambda, inputs)
  local variable = Bubble:new(measuredtime)
  setmetatable(variable, Variable)

  variable._inputs = inputs or {}

  variable._value = nil
  variable._lambda = lambda

  return variable
end

--- Memoise and return the value of the variable at its measured time.
function Variable:value()
  if self._value == nil then
    self._value = self._lambda(self.measuredtime, self.inputs)
  end
  return self._value
end
