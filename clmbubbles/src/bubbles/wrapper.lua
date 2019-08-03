Wrapper = {}
Wrapper.__index = Wrapper

--- Wrap a bubble in an interface for convenient use with the game loop.
function Wrapper:new(bubble)
  local wrapper = {}
  setmetatable(wrapper, Wrapper)

  wrapper.bubble = bubble
  wrapper.time = 0

  return wrapper
end

--- Advance the wrapper by the given time.
function Wrapper:advance(deltatime)
  self.time = self.time + deltatime
end

--- Draw the bubble through the given camera.
function Wrapper:draw(camera)
  self.bubble, todraw = self.bubble:extrapolate(self.time)
  todraw:draw(camera)
end
