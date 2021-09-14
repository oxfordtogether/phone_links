class SignupActionComponent < ViewComponent::Base
  delegate :icon, :button_link_to, to: :helpers

  def initialize(person:)
    @person = person
  end
end
