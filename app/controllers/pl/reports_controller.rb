class Pl::ReportsController < Pl::PlController
  before_action :set_report, only: %i[show update]

  def index
    @pod = current_pod_leader.pod

    case params[:view]
    when "archived"
      @pagy, @reports = pagy(Report.where(match_id: @pod.matches.map(&:id)).where.not(archived_at: nil).order(created_at: :desc), items: 20)
    when "all"
      @pagy, @reports = pagy(Report.where(match_id: @pod.matches.map(&:id)).order(created_at: :desc), items: 20)
    else # inbox
      @pagy, @reports = pagy(Report.where(match_id: @pod.matches.map(&:id)).where(archived_at: nil).order(created_at: :desc), items: 20)
    end
  end

  def show
    pod = current_pod_leader.pod
    @report_ids = Report.where(match_id: pod.matches.map(&:id)).sort_by(&:created_at).map(&:id)

    current_report_index = @report_ids.index(params[:id].to_i)
    @current_report_number = current_report_index + 1

    @prev_url = if current_report_index != 0
                  pl_report_path(current_pod_leader, @report_ids[current_report_index - 1])
                else
                  pl_reports_path(current_pod_leader)
                end
    @next_url = if current_report_index != @report_ids.size - 1
                  pl_report_path(current_pod_leader, @report_ids[current_report_index + 1])
                else
                  pl_reports_path(current_pod_leader)
                end

    @total_reports = @report_ids.size

    @current_pod_leader = current_pod_leader
  end

  def update
    @current_pod_leader = current_pod_leader
    archive = report_params[:archive] == "true"

    if @report.update({ archived_at: archive ? DateTime.now : nil })
      redirect_to pl_report_path(current_pod_leader, @report), notice: "Report was successfully #{archive ? 'archived' : 'unarchived'}."
    else
      render :show
    end
  end

  private

  def set_report
    @report = Report.find(params[:id])

    redirect_to "/invalid_permissions_for_page" if @report.match.pod != current_pod_leader.pod
  end

  def report_params
    params.require(:report).permit(:archive)
  end
end
