Rope = {}
Rope.__index = Rope

--- Create a new rope with a specific number of segments.
function Rope:new(segments)
  local rope = {}
  setmetatable(rope, Rope)

  rope.segments = {}
  for i = 1, segments do
    rope.segments[i] = {
      angle = 0,
      extension = 0
    }
  end

  return rope
end

--- Determine the position of each rope segment.
function Rope:determinepositions()
  local positions = {{x = 0, y = 0}}
  for i, segment in ipairs(self.segments) do
    local length = math.exp(segment.extension)
    local cosine = math.cos(segment.angle)
    local sine = math.sin(segment.angle)
    positions[i + 1] = {
      x = positions[i].x + length * cosine,
      y = positions[i].y + length * sine
    }
  end
  self.positions = positions
end

--- Draw the segments of the rope using the given transform.
function Rope:draw(transform)
  local coordinates = {}
  for _, point in ipairs(self.positions) do
    local x, y = transform(point)
    table.insert(coordinates, x)
    table.insert(coordinates, y)
  end
  love.graphics.line(coordinates)
end
