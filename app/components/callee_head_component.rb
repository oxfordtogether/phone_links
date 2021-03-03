class CalleeHeadComponent < ViewComponent::Base
  delegate :icon, to: :helpers

  def initialize(callee:)
    @callee = callee
  end
end
