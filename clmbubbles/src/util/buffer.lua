Buffer = {}
Buffer.__index = Buffer

--- Create a buffer, which remembers the last n values given to
-- it as key-value pairs.
function Bubble:new(buffersize)
  local buffer = {}
  setmetatable(buffer, Buffer)

  buffer.buffersize = buffersize
  buffer.overwriteindex = 1
  buffer.queue = {}
  buffer.lookup = {}

  return buffer
end

--- Store the given key-value pair in the buffer.
function Buffer:store(key, value)
  local overwritekey = self.queue[self.overwriteindex]
  if overwritekey ~= nil then
    self.lookup[overwritekey] = nil
  end
  self.queue[self.overwriteindex] = key
  self.lookup[key] = value
  self:_incrementindex()
end

--- Retrieve the value associated with the given key.
function Buffer:retrieve(key)
  return self.lookup[key]
end

--- Increment the overwrite index, wrapping it if necessary.
function _incrementindex()
  self.overwriteindex = self.overwriteindex + 1
  if self.overwriteindex > self.buffersize then
    self.overwriteindex = 1
  end
end
