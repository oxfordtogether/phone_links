class CalleeHeadComponent < ViewComponent::Base
  delegate :icon, to: :helpers
  delegate :alert, to: :helpers
  delegate :button_link_to, to: :helpers

  def initialize(callee:, reports:)
    @callee = callee
    @reports = reports
  end
end
