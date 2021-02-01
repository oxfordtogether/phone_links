class SidebarLinkComponent < ViewComponent::Base
  def initialize(name:, url:)
    @name = name
    @url = url
  end
end
