class A::PagesController < A::AController
  def home
    @waiting_list_count = Callee.with_matches.all.filter(&:waiting_list).count
    @provisional_matches_count = Match.all.filter(&:provisional).count

    # @callers = Caller.all
    # @callees = Callee.all
    # @matches = Match.all
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
