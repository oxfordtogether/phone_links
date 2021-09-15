class TimelineItemComponent < ViewComponent::Base
  renders_one :title
  renders_one :meta
  renders_one :body
  delegate :icon, :format_date, to: :helpers

  attr_reader :icon_name, :icon_colour, :time

  def initialize(icon:, icon_colour:, time:, is_last: false)
    @icon_name = icon
    @icon_colour = icon_colour
    @is_last = is_last
    @time = time
  end

  def is_last_item?
    @is_last
  end
end
