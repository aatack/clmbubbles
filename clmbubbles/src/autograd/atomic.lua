require "util.strings"
require "util.functional"

Expression = {}

--- Return an empty expression.
function _expression()
  local e = {}
  setmetatable(e, Expression)
  return e
end

--- Determine whether or not the given table is an expression.
function isexpression(candidate)
  if type(candidate) ~= "table" then
    return false
  else
    return getmetatable(candidate) == Expression
  end
end

--- Return an expression that picks a specific value from
-- its source table.
function pointer(location)
  local p = _expression()
  local index = nestedindexlambda(splitstring(location, "."))

  local one = constant(1)
  local zero = constant(0)

  --- Evaluate the pointer for a given source table.
  function p:evaluate(source)
    return index(source)
  end

  --- Return the derivative of the pointer's value with
  -- respect to some other value.
  function p:derivative(wrt)
    if self == wrt then
      return one
    else
      return zero
    end
  end

  return p
end

--- Return a nested table of pointers, with the same structure
-- as the input nested table, where each leaf is a pointer pointing
-- to its own location within the table.
function pointersfor(nestedtable, currentpath)
  if type(nestedtable) ~= "table" then
    if currentpath == nil or string.len(currentpath) == 0 then
      error("first input to pointersfor must be a table")
    end
    return pointer(string.sub(currentpath, 1, string.len(currentpath) - 1))
  else
    local path = currentpath or ""
    local result = {}
    for key, value in pairs(nestedtable) do
      result[key] = pointersfor(value, path .. key .. ".")
    end
    return result
  end
end

--- Return an expression describing a constant value.
function constant(x)
  local c = _expression()

  --- Evaluate the constant.
  function c:evaluate(_)
    return x
  end

  --- Return an expression representing the derivative
  -- of the constant with respect to another value, which
  -- is always zero.
  function c:derivative(_)
    return constant(0)
  end

  return c
end

--- Return the negation of an expression.
function negate(x)
  local n = _expression()

  function n:evaluate(source)
    return -x:evaluate(source)
  end

  function n:derivative(wrt)
    return negate(x:derivative(wrt))
  end

  return n
end

--- Return an expression representing the value of
-- another expression subtracted from one.
function subfromone(p)
  local s = _expression()

  function s:evaluate(source)
    return 1 - p:evaluate(source)
  end

  function derivative(wrt)
    return negate(p:derivative(wrt))
  end

  return s
end
