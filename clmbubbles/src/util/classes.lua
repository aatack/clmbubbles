function class(parent)
  local object = {}
  object.__index = object
  setmetatable(object, parent)
  object:init = function ()
    local instance = {}
      setmetatable(instance, object)
    return instance
  end
  return object
end
