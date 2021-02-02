class WaitlistHeadComponent < ViewComponent::Base
  delegate :nav_tabs, to: :helpers
  def initialize; end
end
