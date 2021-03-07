# frozen_string_literal: true

class AlertingComponent < ViewComponent::Base
  delegate :icon, to: :helpers
  with_content_areas :title, :info

  def initialize; end
end
