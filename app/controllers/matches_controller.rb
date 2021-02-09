class MatchesController < ApplicationController
  before_action :set_match, only: %i[show edit update]

  def show; end

  # pod/:id/match/new
  def new
    @pod = Pod.find(params[:id])
    @match = Match.new(start_date: Date.today)
  end

  def edit; end

  def create
    @pod_id = match_params[:pod_id]
    @match = Match.new(match_params.except(:pod_id))

    if @match.save
      redirect_to @match, notice: "Match was successfully created."
    else
      @pod = Pod.find(@pod_id)
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

  private

  def set_match
    @match = Match.find(params[:id])
  end

  def match_params
    params.require(:match).permit(:pod_id, :pending, :start_date, :end_date, :caller_id, :callee_id)
  end
end
