class PersonHeadComponent < ViewComponent::Base
  delegate :nav_tabs, to: :helpers
  delegate :icon, to: :helpers
  delegate :button_link_to, to: :helpers

  def initialize(person:)
    @person = person
  end
end
