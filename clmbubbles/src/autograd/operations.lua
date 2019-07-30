require "autograd.atomic"

--- Return an expression representing the sum of two
-- other expressions.
function sum(x, y)
  local s = {}

  function s:evaluate(source)
    return x:evaluate(source) + y:evaluate(source)
  end

  function s:derivative(wrt)
    return sum(
      x:derivative(wrt),
      y:derivative(wrt)
    )
  end

  return s
end

--- Calculate the result of subtracting the latter
-- expression from the former.
function difference(x, y)
  local d = {}

  function d:evaluate(source)
    return x:evaluate(source) - y:evaluate(source)
  end

  function d:derivative(wrt)
    return difference(
      x:derivative(wrt),
      y:derivative(wrt)
    )
  end

  return d
end

--- Multiply an expression by a constant.
function constantproduct(expression, constant)
  local cp = {}

  function cp:evaluate(source)
    return constant * expression:evaluate(source)
  end

  function cp:derivative(wrt)
    return constantproduct(expression:derivative(wrt), constant)
  end

  return cp
end

--- Represent the product of two expressions.
function product(u, v)
  local p = {}

  function p:evaluate(source)
    return u:evaluate(source) * v:evaluate(source)
  end

  function p:derivative(wrt)
    return sum(
      product(u:derivative(wrt), v),
      product(v:derivative(wrt), u)
    )
  end

  return p
end

--- Represent the square of an expression.
function square(x)
  local s = {}

  function s:evaluate(source)
    local _x = x:evaluate(source)
    return _x * _x
  end

  function s:derivative(wrt)
    return constantproduct(x:derivative(wrt), 2)
  end

  return s
end

--- Represent the division of the former expression by
-- the latter as an expression.
function quotient(u, v)
  local q = {}

  function q:evaluate(source)
    return u:evaluate(source) / v:evaluate(source)
  end

  function q:derivative(wrt)
    return quotient(
      difference(
        product(u:derivative(wrt), v),
        product(v:derivative(wrt), u)
      ),
      square(v)
    )
  end

  return q
end
