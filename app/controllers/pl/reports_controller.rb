class Pl::ReportsController < Pl::PlController
  before_action :set_report, only: %i[show update]

  def index
    if params[:view] == "all"
      @pagy, @reports = pagy(all_reports, items: 20)
    else # inbox
      @pagy, @reports = pagy(inbox_reports, items: 20)
    end
  end

  def show
    @report_ids = if params[:view] == "all"
                    all_reports.map(&:id)
                  else # inbox
                    inbox_reports.map(&:id)
                  end

    current_report_index = @report_ids.index(params[:id].to_i)
    @current_report_number = current_report_index + 1

    @prev_url = if current_report_index != 0
                  pl_report_path(current_pod_leader, @report_ids[current_report_index - 1], { view: params[:view] })
                else
                  pl_reports_path(current_pod_leader, { view: params[:view] })
                end
    @next_url = if current_report_index != @report_ids.size - 1
                  pl_report_path(current_pod_leader, @report_ids[current_report_index + 1], { view: params[:view] })
                else
                  pl_reports_path(current_pod_leader, { view: params[:view] })
                end

    @total_reports = @report_ids.size

    @proposed_matches = current_pod_leader.pod.matches
    @current_pod_leader = current_pod_leader
  end

  def update
    if report_params[:match_id]

      if @report.update(report_params)
        @report.create_events!
        redirect_to pl_report_path(current_pod_leader, @report, { view: params[:view] }), notice: "Report was successfully updated."
      else
        @proposed_matches = current_pod_leader.pod.matches
        render :show
      end

    else

      if params[:view] != "all"
        @report_ids = inbox_reports.map(&:id)
        current_report_index = @report_ids.index(params[:id].to_i)
        next_url = if current_report_index != @report_ids.size - 1
                     pl_report_path(current_pod_leader, @report_ids[current_report_index + 1], { view: params[:view] })
                   else
                     pl_reports_path(current_pod_leader, { view: params[:view] })
                   end
      else
        next_url = pl_report_path(current_pod_leader, @report, { view: params[:view] })
      end

      @current_pod_leader = current_pod_leader
      archive = report_params[:archive] == "true"

      if @report.update({ archived_at: archive ? DateTime.now : nil })
        redirect_to next_url, notice: "Report was successfully #{archive ? 'archived' : 'unarchived'}."
      else
        @proposed_matches = current_pod_leader.pod.matches
        render :show
      end

    end
  end

  private

  def set_report
    @report = Report.find(params[:id])

    redirect_to "/invalid_permissions_for_page" if (@report.match.present? && @report.match.pod != current_pod_leader.pod) || (@report.legacy_pod_id == current_pod_leader.pod)
  end

  def report_params
    params.require(:report).permit(:archive, :match_id)
  end

  def all_reports
    Report
      .where(match_id: current_pod_leader.pod.matches.map(&:id))
      .or(Report.where(legacy_pod_id: current_pod_leader.pod))
      .order(created_at: :desc)
  end

  def inbox_reports
    Report
      .where(match_id: current_pod_leader.pod.matches.map(&:id))
      .or(Report.where(legacy_pod_id: current_pod_leader.pod))
      .where(archived_at: nil)
      .order(created_at: :desc)
  end
end
