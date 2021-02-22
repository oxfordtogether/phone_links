class Pl::ReportsController < Pl::PlController
  before_action :set_report, only: %i[show]

  def index
    @pod = current_pod_leader.pod

    # TO DO
    case params[:view]
    when "archived"
      @pagy, @reports = pagy(Report.where(match_id: @pod.matches.map(&:id)), items: 20)
    when "all"
      @pagy, @reports = pagy(Report.where(match_id: @pod.matches.map(&:id)), items: 20)
    else
      @pagy, @reports = pagy(Report.where(match_id: @pod.matches.map(&:id)), items: 20)
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
  end

  private

  def set_report
    @report = Report.find(params[:id])

    redirect_to "/invalid_permissions_for_page" if @report.match.pod != current_pod_leader.pod
  end

  def report_params
    params.require(:report).permit
  end
end
