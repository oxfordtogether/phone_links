class MatchesController < ApplicationController
  before_action :set_match, only: %i[show edit update move_pods]

  def show; end

  # matches/new
  def new
    pod_id = params[:pod_id]
    @match = Match.new(start_date: Date.today, pod_id: pod_id)
    @redirect_on_cancel = params["redirect_on_cancel"] || "/waitlist/provisional_matches"
  end

  def edit; end

  def create
    @redirect_on_cancel = match_params[:redirect_on_cancel]
    @match = Match.new(match_params.except(:redirect_on_cancel))

    if @match.save
      redirect_to @match, notice: "Match was successfully created."
    else
      @redirect_on_cancel ||= "/waitlist/provisional_matches"
      render :new
    end
  end

  def update
    if @match.update(match_params)
      redirect_to @match, notice: "Match was successfully updated."
    else
      render :edit
    end
  end

  def move_pods; end

  private

  def set_match
    @match = Match.find(params[:id])
  end

  def match_params
    params.require(:match).permit(:pod_id, :pending, :start_date, :end_date, :caller_id, :callee_id, :redirect_on_cancel)
  end
end
