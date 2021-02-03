class SidebarLinkComponent < ViewComponent::Base
  delegate :icon, to: :helpers

  def initialize(name:, url:, icon: nil)
    @name = name
    @url = url
    @icon = icon
  end
end
