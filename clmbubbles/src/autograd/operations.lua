--- Return an expression representing the sum of two
-- other expressions.
function sum(x, y)
  local s = {}

  function s:evaluate(source)
    return x:evaluate(source) + y:evaluate(source)
  end

  function s:derivative(withrespectto)
    return sum(
      x:derivative(withrespectto),
      y:derivative(withrespectto)
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

  function d:derivative(withrespectto)
    return difference(
      x:derivative(withrespectto),
      y:derivative(withrespectto)
    )
  end

  return d
end
