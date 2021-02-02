class WaitlistController < ApplicationController
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
end
