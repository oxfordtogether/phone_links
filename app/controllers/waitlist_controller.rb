class WaitlistController < ApplicationController
  before_action :set_counts, only: %i[callers callees provisional_matches]

  def index
    redirect_to "/waitlist/callers"
  end

  def callers
    @waiting_callers = Caller.all.filter(&:waiting?)
  end

  def callees
    @waiting_callees = Callee.all.filter(&:waiting?)
  end

  def provisional_matches
    @pending_matches = Match.where(pending: true)
  end

  private

  def set_counts
    @waiting_callees_count = Callee.all.filter(&:waiting?).count
    @waiting_callers_count = Caller.all.filter(&:waiting?).count
    @pending_matches_count = Match.where(pending: true).count
  end
end
