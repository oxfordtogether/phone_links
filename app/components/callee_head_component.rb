class CalleeHeadComponent < ViewComponent::Base
  delegate :alert, to: :helpers

  def initialize(callee:)
    @callee = callee
  end
end
