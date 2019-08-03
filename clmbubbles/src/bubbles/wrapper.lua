Wrapper = {}
Wrapper.__index = Wrapper

--- Wrap a bubble in an interface for convenient use with the game loop.
function Wrapper:new(bubble, starttime, limit)
  local wrapper = {}
  setmetatable(wrapper, Wrapper)

  wrapper.bubble = bubble
  wrapper.time = starttime or 0
  wrapper.limit = limit or 1024

  return wrapper
end

--- Advance the wrapper by the given time.
function Wrapper:advance(deltatime)
  if self.time > self.limit then
    local shift = self.limit + self.time
    self.time = self.time - shift

    local shifted
    _, shifted = self.bubble:extrapolate(self.time)
    self.bubble = shifted:rebase(shift)
  end
  self.time = self.time + deltatime
end

--- Draw the bubble through the given camera.
function Wrapper:draw(camera)
  local todraw
  self.bubble, todraw = self.bubble:extrapolate(self.time)
  todraw:draw(camera)
end
