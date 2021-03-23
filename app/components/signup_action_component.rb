class SignupActionComponent < ViewComponent::Base
  delegate :icon, to: :helpers

  def initialize(person:)
    @person = person
  end
end
