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

  def safeguarding_status(*args)
    render SafeguardingStatusBadgeComponent.new(*args)
  end

  def referral_status(*args)
    render ReferralStatusBadgeComponent.new(*args)
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

  def profile_initials(*args)
    render ProfileInitialsComponent.new(*args)
  end

  def callee_feeling(*args)
    render CalleeFeelingComponent.new(*args)
  end

  def caller_feeling(*args)
    render CallerFeelingComponent.new(*args)
  end

  def signup_action(*args)
    render SignupActionComponent.new(*args)
  end

  def toggle(*args)
    render ToggleComponent.new(*args)
  end

  def tooltip(*args)
    render TooltipComponent.new(*args)
  end

  def bar_sparklines(*args)
    render BarSparklinesComponent.new(*args)
  end
end
