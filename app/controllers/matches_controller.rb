class MatchesController < ApplicationController
  before_action :set_match, only: %i[show edit update]

  def show; end

  def new
    @match = Match.new(start_date: Date.today)
  end

  def edit; end

  def create
    @match = Match.new(match_params)

    if @match.save
      redirect_to @match, notice: "Match was successfully created."
    else
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
    params.require(:match).permit(:start_date, :end_date, :pod_id, :caller_id, :callee_id)
  end
end
