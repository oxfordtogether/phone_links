class RoleCategoryBadgeComponent < ViewComponent::Base
  # object with role can be a role itself or an object with a role
  def initialize(object_with_role)
    @role = object_with_role.try(:role) || object_with_role
  end

  attr_reader :role
end
