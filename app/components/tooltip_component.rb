class TooltipComponent < ViewComponent::Base
  renders_one :target_content
  renders_one :target

  def initialize; end
end
