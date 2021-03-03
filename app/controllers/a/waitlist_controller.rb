class A::WaitlistController < A::AController
  before_action :set_counts, only: %i[callers callees provisional_matches]

  def index
    redirect_to a_waitlist_callers_path
  end

  def callers
    @waiting_callers = Caller.all.filter(&:on_waiting_list)
  end

  def callees
    @waiting_callees = Callee.all.filter(&:on_waiting_list)
  end

  def provisional_matches
    @pending_matches = Match.where(pending: true)
  end

  private

  def set_counts
    @waiting_callees_count = Callee.with_matches.all.filter(&:on_waiting_list).count
    @waiting_callers_count = Caller.with_matches.all.filter(&:on_waiting_list).count
    @pending_matches_count = Match.where(pending: true).count
  end
end
