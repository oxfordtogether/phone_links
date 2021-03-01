class C::ReportsController < C::CController
  before_action :set_callee, only: %i[show edit update destroy]

  # GET /callees
  def index
    @current_callee =
    @current_caller = 
    match = Match.where(caller_id: current_caller callee_id: current_id)
    @reports = Report.where(match_id: match)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_report
    @report = Report.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def report_params
    params.require(:report).permit(:match_id, :duration, :summary, :datetime, :callee_state)
  end
end
