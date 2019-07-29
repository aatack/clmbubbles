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
      product(v, v)
    )
  end

  return q
end
