require "bubbles.bubble"

CachedBubble = {}
CachedBubble.__index = CachedBubble
setmetatable(CachedBubble, Bubble)

--- An abstract class which implements the Bubble API, but which also caches
-- the results of its `extrapolate` calls.  It is therefore recommended for
-- bubbles for which multiple extrapolations to a small set of timestamps
-- may be needed, but should not be used for long-lasting bubbles.
function CachedBubble:new(measuredtime)
  local cachedbubble = Bubble:new(measuredtime)
  setmetatable(cachedbubble, CachedBubble)

  cachedbubble._cache = {}

  return cachedbubble
end

--- Return two values.  The second is a new instance of this
-- bubble whose fields have been propagated from its measured time
-- to the given time.  The first returned value is the bubble that
-- produced that result; normally, this will be the same as the
-- bubble the function is called on, but if a discontinuity is
-- crossed then a different bubble will be returned.  This
-- function has undefined behaviour if the passed time is less
-- than the bubble's measured time.
function Bubble:extrapolate(time)
  if self._cache[time] == nil then
    if time < self:time() then
      local source, newinstance = self:result():extrapolate(time)
      local holder = {}
      holder["source"] = source
      holder["newinstance"] = newinstance
      self._cache[time] = holder
    else
      return self:result():extrapolate(time)
    end
  end
  return self._cache[time].source, self._cache[time].newinstance
end
