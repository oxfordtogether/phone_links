class RoleStatusBadgeComponent < ViewComponent::Base
  def initialize(role)
    @role = role
  end

  attr_reader :role
end
