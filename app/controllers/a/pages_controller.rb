class A::PagesController < A::AController
  def home
    @callers = Caller.where.not(status: "left_programme").count
    @matches = Match.live.count
    @reports = Report.count

    @waiting_callees = Callee.where(status: "waiting_list").count
    @provisional_matches = Match.where(status: "provisional").count

    @reports_by_week = Report.where("created_at > ?", 6.months.ago).group_by_week(:created_at).count.map do |k, v|
      { label: k, value: v, background_color: "rgba(54, 162, 235, 0.2)", border_color: "rgba(54, 162, 235, 1)" }
    end
  end

  def support
    render "a/pages/support"
  end

  def search
    @status ||= :start
    @results ||= []
  end

  def admin
    redirect_to a_admin_admins_path
  end

  def callers
    @callers = Caller.all
    render a_admin_callers_path
  end

  def form_responses; end
end
