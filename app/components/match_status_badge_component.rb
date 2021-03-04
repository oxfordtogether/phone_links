class MatchStatusBadgeComponent < ViewComponent::Base
  def initialize(match)
    @match = match
  end

  attr_reader :match
end
