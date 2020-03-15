class BubbleState:
    """Represents the state of a bubble at an arbitrary point in time."""

    pass


class Bubble:

    state_class = None

    def __init__(self, measured_time: float, measured_state: BubbleState):
        """Create an instance of the bubble starting from a measured state."""
        self.measured_time = measured_time
        self.measured_state = measured_state

        self.current_time = self.measured_time
        self.current_state = self.measured_state

    @classmethod
    def state_at_time(cls, time: float, known_state: BubbleState) -> BubbleState:
        """
        Get the bubble's state, from its known state, after the given amount of time.
        
        It may be assumed that the time of the known state is before the given time.
        """
        raise NotImplementedError()

    def go_to(self, time: float):
        """Set the bubble's current state to the given time."""
        if time < self.measured_time:
            raise ValueError("the given time must be greater than the measured time")

        self.current_time = time
        self.current_state = self.state_at_time(
            time - self.measured_time, self.measured_state
        )
