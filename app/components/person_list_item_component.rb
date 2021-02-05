class PersonListItemComponent < ViewComponent::Base
  def initialize(person_or_role)
    @person = person_or_role.respond_to?(:person) ? person_or_role.person : person_or_role
  end

  attr_reader :person
end
