require "types.base"

NestedBubble = {}
NestedBubble.__index = NestedBubble
setmetatable(NestedBubble, CLMBubble)

--- Create a bubble whose latent variables are a table or
-- set of nested tables.
function NestedBubble:new(latvars)
  local nestedBubble = CLMBubble:new(latvars)
  setmetatable(nestedBubble, NestedBubble)

  return nestedBubble
end

--- In place, add each value from source to each value in
-- target.  Both can be assumed to have the same structure
-- as the bubble's latent variables.
function NestedBubble:latsum(target, source)
  sumtables(target, source)
end

--- Add the root elements of the source table to those of
-- the target table in place.
function sumtables(target, source)
  for key, _ in pairs(target) do
    if type(target[key]) == "table" then
      sumtables(target[key], source[key])
    else
      target[key] = target[key] + source[key]
    end
  end
end

--- In place, multiply each value from the target by the
-- corresponding value in the source.  Both can be assumed
-- to have the same structure as the bubble's latent
-- variables.
function NestedBubble:latmul(target, source)
  multables(target, source)
end

--- Add the root elements of the target table by those of
-- the source table in place.
function multables(target, source)
  for key, _ in pairs(target) do
    if type(target[key]) == "table" then
      multables(target[key], source[key])
    else
      target[key] = target[key] * source[key]
    end
  end
end

--- Make a deep copy of the given set of latent variables.
function NestedBubble:latcopy(source)
  return copytable(source)
end

--- Check whether a value is a table or a primitive and
-- copy it accordingly.
function copytable(source)
  if type(source) == "table" then
    result = {}
    for k, v in pairs(source) do
      result[k] = copytable(v)
    end
    return result
  else
    return source
  end
end
