class A::PagesController < A::AController
  def home
    @current_user = current_user

    @inbox_items = Event
                   .where(type: "Events::FlagChanged")
                   .where(replacement_event_id: nil)
                   .filter { |e| e["non_sensitive_data"]["flag_in_progress"] }

    @waiting_list_count = Callee.with_matches.all.filter(&:on_waiting_list).count
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
