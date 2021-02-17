class C::ReportsController < C::CController
  before_action :set_report, only: %i[show edit update destroy]

  # GET /reports
  def index
    @reports = Report.all
  end

  # GET /reports/1
  def show; end

  # GET /reports/new
  def new
    @report = Report.new
    @redirect_on_cancel = params[:redirect_on_cancel] || c_path
    # @redirect_on_submit = params[:redirect_on_submit] || c_report_path
  end

  # GET /reports/1/edit
  def edit; end

  # POST /reports
  def create
    @report = Report.new(report_params)

    if @report.save
      redirect_to c_reports_path(@report), notice: "Report was successfully created."
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
