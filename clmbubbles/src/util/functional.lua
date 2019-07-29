--- Return the head of an array.
function head(source)
  return source[1]
end

--- Return all elements of an array except the head.
function tail(source)
  local target = {}
  for i = 2, #source do
    table.insert(target, source[i])
  end
  return target
end

--- Index a table repeatedly.
function nestedindex(source, path)
  if #path == 0 then
    return source
  else
    return nestedindex(source[head(path)], tail(path))
  end
end

--- Return a function that indexes a table repeatedly.  May
-- be more performant than nestedindex due to not repeatedly
-- calling tail.
function nestedindexlambda(path)
  if #path == 0 then
    return identity
  else
    local h = head(path)
    local inner = nestedindexlambda(tail(path))
    return function(source)
      return inner(source[h])
    end
  end
end

--- The identity function, which returns its input.
function identity(x)
  return x
end
