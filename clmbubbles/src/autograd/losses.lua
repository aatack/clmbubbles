require "autograd.operations"
require "autograd.atomic"

--- Calculate the mean squared error of two sides of an
-- equation.  Useful for when two values are intended to
-- be equal.
function mse(lhs, rhs)
  return square(difference(lhs, rhs))
end

--- Measure the loss of a value, interpreted as a probability,
-- which is driven to a target probability (normally 0 or 1).
-- This is suitable for functions in which the target probability
-- will change: if it is known in advance, use either
-- positivebce or negativebce.
function binarycrossentropy(value, target)
  local one = constant(1)
  return negate(sum(
    product(target, ln(value)),
    product(
      subfromone(probability),
      ln(subfromone(probability))
    )
  ))
end

--- Binary crossentropy loss function where the target is
-- always 1.
function positivebce(probability)
  return negate(log(probability))
end

--- Binary crossentrop loss function where the target is
-- always 0.
function negativebce(probability)
  local one = constant(1)
  return negate(ln(subfromone(probability)))
end
