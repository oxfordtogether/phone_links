class PersonHeadComponent < ViewComponent::Base
  delegate :nav_tabs, to: :helpers
  delegate :icon, to: :helpers

  def initialize(person:)
    @person = person
  end
end
