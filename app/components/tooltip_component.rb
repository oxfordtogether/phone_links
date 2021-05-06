class TooltipComponent < ViewComponent::Base
  renders_one :content
  renders_one :target

  def initialize; end
end
