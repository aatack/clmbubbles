require "bubbles.bubble"

Ball = {}
Ball.__index = Ball
setmetatable(Ball, Bubble)

--- Create a ball which falls according to gravity.
function Ball:new(measuredtime, position, velocity)
  local ball = Bubble:new(measuredtime)
  setmetatable(ball, Ball)

  ball.position = position
  ball.velocity = velocity
  ball.acceleration = -9.81
  ball.radius = 5

  return ball
end

--- Calculate and return the time at which this bubble's next
-- discontinuity occurs.  Return `math.huge` if there is no
-- foreseeable discontinuity.
function Bubble:_time()
  return math.huge
end

--- Calculate and return the state of this bubble immediately
-- after the next discontinuity.  The `measuredtime` field of the
-- result should equal the `discontinuity.time` field of this bubble.
function Bubble:_result()
  error("Ball:_result is a degenerate case")
end

--- Assuming the given time is between the measured and discontinuity
-- times, return a new instance of this bubble where its values have
-- been extrapolated to the given time.
function Bubble:_extrapolate(time)
  local dt = time - self.measuredtime
  return Ball:new(
    time,
    self.position + (self.velocity * dt) + (0.5 * self.acceleration * dt * dt),
    self.velocity + self.acceleration * dt
  )
end

--- Return a new bubble whose values are unchanged but whose
-- measured time has been shifted backwards by the given amount.
function Bubble:rebase(delta)
  return Ball:new(self.measuredtime - delta, self.position, self.velocity)
end
