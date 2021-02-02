class WaitlistHeadComponent < ViewComponent::Base
  delegate :nav_tabs, to: :helpers
  delegate :button_link_to, to: :helpers

  def initialize; end
end
