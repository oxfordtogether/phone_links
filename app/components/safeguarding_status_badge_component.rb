class SafeguardingStatusBadgeComponent < ViewComponent::Base
  def initialize(safeguarding_concern)
    @safeguarding = safeguarding_concern
  end

  attr_reader :safeguarding
end
