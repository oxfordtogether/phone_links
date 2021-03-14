class EventComponent < ViewComponent::Base
  delegate :timeline_item, :format_date, :callee_feeling, :caller_feeling, :icon, to: :helpers

  def initialize(event:, last_event:)
    @event = event
    @last_event = last_event
  end
end
