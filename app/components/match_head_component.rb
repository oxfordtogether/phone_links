class MatchHeadComponent < ViewComponent::Base
  delegate :nav_tabs, to: :helpers
  delegate :role_badge, to: :helpers
  delegate :format_date_as_relative, to: :helpers
  delegate :format_date_range, to: :helpers

  def initialize(match:)
    @match = match
  end
end
