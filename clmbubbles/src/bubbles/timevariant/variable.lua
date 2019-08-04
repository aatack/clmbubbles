require "bubbles.bubble"

Variable = {}
Variable.__index = Variable
setmetatable(Variable, Bubble)

--- An abstract class which stores information about how a variable's value
-- changes as a function of time, as well as (optionally) similar data for its
-- derivatives.  The `inputs` parameter should be a table of all variables
-- upon which this variable is dependent.  The `valuefunction` parameter
-- should be a function whose first argument is scalar for the time at which
-- the value is being calculated, and whose second argument is the inputs
-- dictionary.
function Variable:new(
  measuredtime, inputs, valuefunction, derivativefunctions
)
  local variable = Bubble:new(measuredtime)
  setmetatable(variable, Variable)

  variable._inputs = inputs or {}

  variable._value = nil
  variable._valuefunction = valuefunction
  variable._derivatives = {}
  variable._derivativefunctions = derivativefunctions or {}

  return variable
end

--- Memoise and return the value of the variable at its measured time.
function Variable:value()
  if self._value == nil then
    self._value = self._valuefunction(self.measuredtime, self.inputs)
  end
  return self._value
end

--- Return a function for the nth derivative of the variable.  If no
-- function exists for a derivative of that depth, one is calculated by
-- repeatedly taking first-order approximations (note that this may
-- cause significant performance hits).
function Variable:derivativefunction(n)
  if #self._derivativefunctions == 0 then
    self._derivativefunctions[1] = _derivative(self._valuefunction)
  end
  while #self._derivativefunctions < n do
    table.insert(
      self._derivativefunctions,
      _derivative(self._derivativefunctions[#self._derivativefunctions])
    )
  end
  return self._derivativefunctions[n]
end

--- Return the nth derivative of the variable with respect to time at
-- its measured time.
function Variable:derivative(n)
  while #self._derivatives < n do
    table.insert(
      self._derivatives,
      self:derivativefunction(n)(self.measuredtime, self.inputs)
    )
  end
  return self._derivatives[n]
end

--- Return a first-order numerical estimation of the function's
-- derivative with respect to its sole argument.
function _derivative(lambda, epsilon)
  local epsilon = epsilon or 1e-5
  return function(t, variables)
    return (
      (lambda(t + epsilon, variables) - lambda(t - epsilon, variables)) /
      (2 * epsilon)
    )
  end
end
