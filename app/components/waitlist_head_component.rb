class WaitlistHeadComponent < ViewComponent::Base
  delegate :nav_tabs, to: :helpers
  delegate :button_link_to, to: :helpers

  def initialize(waiting_callers_count:, waiting_callees_count:, provisional_matches_count:)
    @waiting_callers_count = waiting_callers_count
    @waiting_callees_count = waiting_callees_count
    @provisional_matches_count = provisional_matches_count
  end
end
