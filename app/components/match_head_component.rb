class MatchHeadComponent < ViewComponent::Base
  delegate :tailwind_form_with, :nav_tabs, :role_badge, :format_date, :format_date_range, :alert, :info, :button_link_to, to: :helpers

  def initialize(match:)
    @match = match
  end
end
