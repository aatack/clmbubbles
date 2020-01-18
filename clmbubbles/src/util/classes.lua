--- Create a new class, automatically setting its parent class
-- to the given value.
function class(parent)
  local object = {}
  object.__index = object
  setmetatable(object, parent)
  function object:init()
    local instance = {}
      setmetatable(instance, object)
    return instance
  end
  return object
end
