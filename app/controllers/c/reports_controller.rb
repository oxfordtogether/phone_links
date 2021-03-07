class C::ReportsController < C::CController
  before_action :set_report, only: %i[show edit update destroy]

  # GET /reports
  def index
    redirect_to c_path
  end

  # GET /reports/1
  def show; end

  # GET /reports/new
  def new
    match_id = params[:match_id]
    @report = Report.new(match_id: match_id, date_of_call: Date.today)
    @matches = current_caller.matches.where(id: match_id)
  end

  # GET /reports/1/edit
  def edit; end

  # POST /reports
  def create
    @report = Report.new(report_params)

    if @report.save
      redirect_to c_reports_path, notice: "Report was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /reports/1
  def update
    if @report.update(report_params)
      redirect_to @report, notice: "Report was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /reports/1
  def destroy
    @report.destroy
    redirect_to reports_url, notice: "Report was successfully destroyed."
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
