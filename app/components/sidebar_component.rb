class SidebarComponent < ViewComponent::Base
  delegate :icon, to: :helpers

  renders_one :navbar_content

  def initialize; end
end
