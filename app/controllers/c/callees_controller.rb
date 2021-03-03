class C::CalleesController < C::CController
  before_action :set_callee, only: %i[show edit update destroy]

  # GET /callees
  def show
    @current_caller = current_caller
    match = Match.where(caller_id: current_caller, callee_id: @callee.id).first
    @reports = Report.where(match_id: match.id)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_callee
    @callee = Callee.find(params[:id])
  end
end
