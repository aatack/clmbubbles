Camera = {}
Camera.__index = Camera

--- Create a camera for simply drawing game worlds.  Mostly copies the
-- API exposed by `love.graphics` with some minor changes.  For both world
-- and screen, centre gives the centre coordinates of the camera, while
-- dimensions give half the length of the camera's field of view along
-- that axis.
function Camera:new(centreworld, dimensionsworld, centrescreen, dimensionsscreen)
  local camera = {}
  setmetatable(camera, Camera)

  camera.world = {centre = centreworld, dimensions = dimensionsworld}
  camera.screen = {centre = centrescreen, dimensions = dimensionsscreen}

  return camera
end

--- Transform a point (a table with floating point keys for `x` and `y`)
-- from the world coordinates to the screen coordinates.
function Camera:transformpoint(point)
  return {
    x = (
      self.screen.centre.x +
      ((point.x - self.world.centre.x) / self.world.dimensions.x) *
      self.screen.dimensions.x
    ),
    y = (
      self.screen.centre.y -
      ((point.y - self.world.centre.y) / self.world.dimensions.y) *
      self.screen.dimensions.y
    )
  }
end

--- Transform a distance from the world space to the screen space.
-- Produces undefined behaviour if the aspect ratio is not maintained
-- between the world and screen.
function Camera:transformdistance(distance)
  return distance * (self.screen.dimensions.x / self.world.dimensions.x)
end

--- Create a camera that spans the entire screen, while maintaining aspect
-- ratio, as a function of its centre in the world and the number of world
-- units that will be displayed across the camera's width.
function Camera:fullscreen(centreworld, widthworld)
  local halfwidth = love.graphics.getWidth() / 2
  local halfheight = love.graphics.getHeight() / 2
  return Camera:new(
    centreworld,
    {x = widthworld / 2, y = (widthworld / 2) * (halfheight / halfwidth)},
    {x = halfwidth, y = halfheight},
    {x = halfwidth, y = halfheight}
  )
end

--- While maintaining the width of the camera in the game world, set it
-- to cover the entirety of the screen.
function Camera:setfullscreen()
  local halfwidth = love.graphics.getWidth() / 2
  local halfheight = love.graphics.getHeight() / 2

  self.world.dimensions.y = (widthworld / 2) * (halfheight / halfwidth)
  self.screen.centre = {x = halfwidth, y = halfheight}
  self.screen.dimensions = {x = halfwidth, y = halfheight}
end

--- Draw a circle.  Produces undefined behaviour if the aspect ratio is
-- not maintained between the world and screen spaces.
function Camera:circle(mode, centre, radius)
  local transformed = self:transformpoint(centre)
  love.graphics.circle(
    mode, transformed.x, transformed.y, self:transformdistance(radius)
  )
end

--- Draw a line from a series of points in the world space.
function Camera:line(points)
  local coordinates = {}
  for _, point in ipairs(points) do
    local transformed = self:transformpoint(point)
    table.insert(coordinates, transformed.x)
    table.insert(coordinates, transformed.y)
  end
  love.graphics.line(coordinates)
end

--- Draw a polygon bounded by a series of points in the world space.
function Camera:polygon(mode, points)
  local coordinates = {}
  for _, point in ipairs(points) do
    local transformed = self:transformpoint(point)
    table.insert(coordinates, transformed.x)
    table.insert(coordinates, transformed.y)
  end
  love.graphics.polygon(mode, coordinates)
end
