module ComponentHelper
  def role_badge(*args)
    render RoleCategoryBadgeComponent.new(*args)
  end

  def blue_link(*args)
    render LinkToComponent.new(*args)
  end
end
