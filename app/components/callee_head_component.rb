class CalleeHeadComponent < ViewComponent::Base
  delegate :icon, :address_to_string, :button_link_to, :nav_tabs, to: :helpers

  def initialize(callee:)
    @callee = callee
  end
end
