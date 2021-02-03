module ComponentHelper
  def role_badge(*args)
    render RoleCategoryBadgeComponent.new(*args)
  end
end
