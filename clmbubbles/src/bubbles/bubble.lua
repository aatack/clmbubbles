require "util.classes"

Bubble = class()
Bubble.newevent = {}

--- Create a new bubble, which evolves over time from an initial
-- state.
function Bubble:new()
  local bubble = Bubble:init()

  bubble.events.incoming = {}
  bubble.events.outgoing = {}

  bubble.initial = {}
  bubble.current = {}
  bubble.referencetime = 0
  bubble.currenttime = 0

  return bubble
end

--- Create a new bubble type, which is a subtype of the bubble type
-- upon which it is called.
function Bubble:childclass(updatefunction)
  local childclass = class(self)

  childclass.updatefunction = updatefunction
  setmetatable(childclass.newevent, self.newevent)

  return childclass
end
