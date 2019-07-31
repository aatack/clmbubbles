require "bubbles.nested"
require "autograd.atomic"
require "util.functional"

ExpressionBubble = {}
ExpressionBubble.__index = ExpressionBubble
setmetatable(ExpressionBubble, NestedBubble)

--- Create an expression bubble, which uses an expression
-- for loss to automatically calculate its slope and curve.
function ExpressionBubble:new(latvars, lossexpression)
  local expressionbubble = NestedBubble:new(latvars)
  setmetatable(expressionbubble, ExpressionBubble)

  expressionbubble._loss = lossexpression

  expressionbubble._slope = conditionalmap(
    isexpression,
    function (var)
      return expressionbubble._loss:derivative(var)
    end,
    pointersfor(expressionbubble.latvars.value)
  )

  return expressionbubble
end

--- Evaluate the loss expression on the given latent variables.
function ExpressionBubble:loss(latvars)
  return self._loss:evaluate(latvars)
end

function ExpressionBubble:slope(latvars, _)
  return conditionalmap(
    isexpression,
    function (var)
      return var:evaluate(latvars)
    end,
    self._slope
  )
end
