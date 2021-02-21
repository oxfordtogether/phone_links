class EventComponent < ViewComponent::Base
  delegate :timeline_item, to: :helpers

  def initialize(event:, last_event:)
    @event = event
    @last_event = last_event
  end
end
