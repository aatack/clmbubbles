require "bubbles.bubble"

Graph = {}
Graph.__index = Graph
setmetatable(Graph, Bubble)

--- Create a new graph, which stores the values of time-dependent
-- variables, as well as information about how they change over time.
function Graph:new(measuredtime, variables)
  local graph = Bubble:new(measuredtime)
  setmetatable(graph, Graph)

  graph.variables = variables or {}

  return graph
end

--- Calculate and return the time at which this bubble's next
-- discontinuity occurs.  Return `math.huge` if there is no
-- foreseeable discontinuity.
function Graph:_time()
  local minimum = math.huge
  for _, variable in pairs(self.variables) do
    if variable:time() < minimum then
      minimum = variable:time()
    end
  end
  return minimum
end

--- Calculate and return the state of this bubble immediately
-- after the next discontinuity.  The `measuredtime` field of the
-- result should equal the `discontinuity.time` field of this bubble.
function Graph:_result()
  local time = self:time()
  local updated = {}

  for key, variable in pairs(self.variables) do
    if variable:time() <= time then
      updated[key] = variable:result()
    else
      updated[key] = variable
    end
  end

  return Graph:new(time, updated)
end

--- Assuming the given time is between the measured and discontinuity
-- times, return a new instance of this bubble where its values have
-- been extrapolated to the given time.
function Graph:_extrapolate(time)
  local updated = {}
  for key, variable in pairs(self.variables) do
    _, extrapolated = variable:extrpolate(time)
    updated[key] = extrpolated
  end
  return self, Graph:new(time, updated)
end

--- Return a new bubble whose values are unchanged but whose
-- measured time has been shifted backwards by the given amount.
function Graph:rebase(delta)
  -- TODO: write this to improve performance (ie. prevent undue copying)
  local updated = {}
  for key, variable in pairs(self.variables) do
    updated[key] = variable:rebase(delta)
  end
  return Graph:new(self.measuredtime - delta, updated)
end
