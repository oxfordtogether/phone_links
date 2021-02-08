class AdminHeadComponent < ViewComponent::Base
  delegate :nav_tabs, to: :helpers
  delegate :alert, to: :helpers

  def initialize; end
end
