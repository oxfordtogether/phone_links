class Pl::ReportingController < Pl::PlController
  def pod_reporting_pdf
    @pod = @fetcher.pod(params[:id])

    @all_reports = Report.where(match_id: Pod.find(@pod.id).matches.map(&:id)).or(Report.where(legacy_pod_id: @pod.id))
    @reports = @all_reports.where("created_at >= ?", "2020-01-01")

    @reports_by_month = @reports.group_by_month(:created_at).count

    render pdf: "#{@pod.name} Report", disposition: "attachment", orientation: "Landscape" # , show_as_html: true
  end
end
