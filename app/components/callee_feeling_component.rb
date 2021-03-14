class CalleeFeelingComponent < ViewComponent::Base
  delegate :icon, to: :helpers

  def initialize(feeling:)
    @feeling = feeling
  end
end
