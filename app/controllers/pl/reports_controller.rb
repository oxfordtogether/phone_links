class Pl::ReportsController < Pl::PlController
  before_action :set_report, only: %i[show update]

  def index
    @pod = @fetcher.pod(params[:id])

    if params[:view] == "all"
      @pagy, @reports = pagy(@fetcher.all_reports(@pod.id), items: 20)
    else # inbox
      @pagy, @reports = pagy(@fetcher.inbox_reports(@pod.id), items: 20)
    end
  end

  def show
    @report_ids = if params[:view] == "all"
                    @fetcher.all_reports(@pod.id).map(&:id)
                  else # inbox
                    @fetcher.inbox_reports(@pod.id).map(&:id)
                  end

    current_report_index = @report_ids.index(params[:id].to_i)
    return redirect_to pl_reports_path(@pod, { view: params[:view] }) if current_report_index.nil?

    @current_report_number = current_report_index + 1

    @prev_url = if current_report_index != 0
                  pl_report_path(@report_ids[current_report_index - 1], { view: params[:view] })
                else
                  pl_reports_path(@pod, { view: params[:view] })
                end
    @next_url = if current_report_index != @report_ids.size - 1
                  pl_report_path(@report_ids[current_report_index + 1], { view: params[:view] })
                else
                  pl_reports_path(@pod, { view: params[:view] })
                end

    @total_reports = @report_ids.size

    @proposed_matches = @pod&.matches
  end

  def update
    if report_params[:match_id]
      if @report.update(report_params)
        redirect_to pl_report_path(@report, { view: params[:view] }), notice: "Report was successfully updated."
      else
        @proposed_matches = @pod&.matches
        render :show
      end

    else

      if params[:view] != "all"
        @report_ids = @fetcher.inbox_reports(@pod.id).map(&:id)
        current_report_index = @report_ids.index(params[:id].to_i)

        return redirect_to pl_reports_path(@pod, { view: params[:view] }) if current_report_index.nil?
        next_url = if current_report_index != @report_ids.size - 1
                     pl_report_path(@report_ids[current_report_index + 1], { view: params[:view] })
                   else
                     pl_reports_path(@pod, { view: params[:view] })
                   end
      else
        next_url = pl_report_path(@report, { view: params[:view] })
      end

      archive = report_params[:archive] == "true"

      if @report.update({ archived_at: archive ? DateTime.now : nil })
        redirect_to next_url, notice: "Report was successfully #{archive ? 'archived' : 'unarchived'}."
      else
        @proposed_matches = @pod&.matches
        render :show
      end

    end
  end

  private

  def set_report
    @report = @fetcher.report(params[:id])
    @pod = Pod.find(@report&.match&.pod_id || @report&.legacy_pod_id)
  end

  def report_params
    params.require(:report).permit(:archive, :match_id)
  end
end
