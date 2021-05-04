class A::DashboardController < A::AController
  NavTabsLinkWithActive = Struct.new(:name, :path, :active?)
  NavTabsLink = Struct.new(:name, :path, :partial_match)

  def index
    if !params[:filter]
      redirect_to a_dashboard_index_path("6_months") unless params[:filter]
      return
    end

    @date_range_options = [
        NavTabsLink.new("Last 6 months", a_dashboard_index_path("6_months")),
        NavTabsLink.new("Last 3 months", a_dashboard_index_path("3_months")),
        NavTabsLink.new("Last month", a_dashboard_index_path("1_month")),
        NavTabsLink.new("Last 2 weeks", a_dashboard_index_path("2_weeks"))
      ]

    period_start = case params[:filter]
    when "6_months"
      6.months.ago
    when "3_months"
      3.months.ago
    when "1_month"
      1.month.ago
    when "2_weeks"
      2.weeks.ago
    end

    @new_matches = Match.where("created_at > ?", period_start).live.count
    @new_callers = Caller.where("created_at > ?", period_start).active.count
    @new_callees = Callee.where("created_at > ?", period_start).active.count

    duration_hash = Report.duration_options_for_select.map(&:reverse).to_h
    @call_duration_raw = Report.where(legacy_pod_id: nil).where("created_at > ?", period_start).group(:duration).count
    @call_duration = duration_hash.map { |k, v| {label: v, value: @call_duration_raw[k.to_s] || 0, background_color: "rgba(54, 162, 235, 0.2)", border_color: "rgba(54, 162, 235, 1)" } }

    callee_feeling_hash = Report.callee_feeling_options_for_select.map(&:reverse).to_h
    @callee_feeling_raw = Report.where(legacy_pod_id: nil).where("created_at > ?", period_start).group(:callee_feeling).count
    @callee_feeling = callee_feeling_hash.map { |k, v| {label: v, value: @callee_feeling_raw[k.to_s] || 0, background_color: "rgba(54, 162, 235, 0.2)", border_color: "rgba(54, 162, 235, 1)" } }

    caller_feeling_hash = Report.callee_feeling_options_for_select.map(&:reverse).to_h
    @caller_feeling_raw = Report.where(legacy_pod_id: nil).where("created_at > ?", period_start).group(:caller_feeling).count
    @caller_feeling = caller_feeling_hash.map { |k, v| {label: v, value: @caller_feeling_raw[k.to_s] || 0, background_color: "rgba(54, 162, 235, 0.2)", border_color: "rgba(54, 162, 235, 1)" } }

    @caller_milestones = Caller.where("created_at > ? and created_at < ?", period_start - 12.months, 12.months.ago)

    @match_report_counts_period_start = Report.where("created_at < ?", period_start).where.not(match_id: nil).group(:match).count.filter { |k, v| v < 50 }
    @match_report_counts_now = Report.where.not(match_id: nil).group(:match).count.filter { |k, v| v >= 50 }
    @match_milestones = @match_report_counts_period_start.keys & @match_report_counts_now.keys
  end
end
