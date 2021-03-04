class A::WaitlistController < A::AController
  before_action :set_counts, only: %i[callers callees provisional_matches]

  def index
    redirect_to a_waitlist_callers_path
  end

  def callers
    @waiting_callers = Caller.all.filter(&:waiting_list)
  end

  def callees
    @waiting_callees = Callee.all.filter(&:waiting_list)
  end

  def provisional_matches
    @provisional_matches = Match.all.filter(&:provisional)
  end

  private

  def set_counts
    @waiting_callees_count = Callee.with_matches.all.filter(&:waiting_list).count
    @waiting_callers_count = Caller.with_matches.all.filter(&:waiting_list).count
    @provisional_matches_count = Match.all.filter(&:provisional).count
  end
end
