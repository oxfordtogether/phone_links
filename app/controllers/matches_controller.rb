class MatchesController < ApplicationController
  before_action :set_match, only: %i[show edit update move_pods]

  def show; end

  # pod/:id/match/new?redirect_on_cancel=/waitlist/matches
  def new
    @pod = Pod.find(params[:id])
    @match = Match.new(start_date: Date.today)
    @redirect_on_cancel = params["redirect_on_cancel"] || pod_path(@pod)
  end

  def edit; end

  def create
    @pod_id = match_params[:pod_id]
    @redirect_on_cancel = match_params[:redirect_on_cancel]
    @match = Match.new(match_params.except(:pod_id))

    if @match.save
      redirect_to @match, notice: "Match was successfully created."
    else
      @redirect_on_cancel ||= pod_path(@pod)
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

  def move_pods; end

  private

  def set_match
    @match = Match.find(params[:id])
  end

  def match_params
    params.require(:match).permit(:pod_id, :pending, :start_date, :end_date, :caller_id, :callee_id, :redirect_on_cancel)
  end
end
