module ComponentHelper
  def role_badge(*args)
    render RoleCategoryBadgeComponent.new(*args)
  end

  def role_status(*args)
    render RoleStatusBadgeComponent.new(*args)
  end

  def match_status(*args)
    render MatchStatusBadgeComponent.new(*args)
  end

  def blue_link(*args)
    render LinkToComponent.new(*args)
  end

  def events_timeline(*args)
    render EventsTimelineComponent.new(*args)
  end

  def reports_list(*args)
    render ReportsListComponent.new(*args)
  end
end
