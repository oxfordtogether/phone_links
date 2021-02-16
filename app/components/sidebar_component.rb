class SidebarComponent < ViewComponent::Base
  delegate :icon, to: :helpers

  with_content_areas :navbar_content

  def initialize; end
end
