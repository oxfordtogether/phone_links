class SidebarComponent < ViewComponent::Base
  delegate :icon, to: :helpers

  def initialize; end
end
