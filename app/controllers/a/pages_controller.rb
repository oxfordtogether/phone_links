class A::PagesController < A::AController
  def home
    @current_user = current_user

    @flagged_people = Person.where(flag_in_progress: true)

    @waiting_list_count = Callee.with_matches.all.filter(&:waiting_list).count
    @provisional_matches_count = Match.all.filter(&:provisional).count
  end

  def support
    render "pages/support"
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
