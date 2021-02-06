class AlertComponent < ViewComponent::Base
  delegate :icon, to: :helpers

  def initialize(title: nil, info: nil)
    @title = title
    @info = info
  end
end
