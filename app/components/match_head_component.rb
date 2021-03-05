class MatchHeadComponent < ViewComponent::Base
  delegate :tailwind_form_with, :nav_tabs, :role_badge, :format_date, :alert, :info, :button_link_to, to: :helpers

  def initialize(match:)
    @match = match
  end
end
