class WaitlistController < ApplicationController
  before_action :set_person, only: %i[show edit update]

  def index
    @callers = Caller.all.filter { |c| c.waiting? }
    @callees = Callee.all.filter { |c| c.waiting? }
  end
end
