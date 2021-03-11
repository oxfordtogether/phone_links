class C::ReportsController < C::CController
  def new
    @match_id = params[:match_id]
    @report = Report.new(match_id: @match_id, date_of_call: Date.today)
    @matches = current_caller.matches.where(id: @match_id)
  end

  def create
    @report = Report.new(report_params)

    if @report.save
      redirect_to c_path, notice: "Report was successfully created."
    else
      @match_id = @report.match.id
      render :new
    end
  end

  private

  def report_params
    params.require(:report).permit(:match_id, :duration, :summary, :date_of_call, :callee_state, :caller_confidence, :concerns, :concerns_notes)
  end
end
