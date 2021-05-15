require 'csv'

class Pl::ReportingController < Pl::PlController
  def pod_reporting_pdf
    @pod = @fetcher.pod(params[:id])

    @all_reports = Report.where(match_id: Pod.find(@pod.id).matches.map(&:id))
    @reports = @all_reports.where("created_at >= ?", "2020-01-01")

    @reports_by_month = @reports.group_by_month(:created_at).count

    render pdf: "#{@pod.name} Report", disposition: "attachment", orientation: "Landscape" # , show_as_html: true
  end

  def pod_reports_csv
    @pod = @fetcher.pod(params[:id])

    all_reports = Report.for_pod(@pod.id).newest_first

    filename = "#{@pod.name} Reports #{Date.today.strftime('%Y%m%d')}.csv"

    send_data reports_csv_string(all_reports), type: "text/csv; charset=utf-8; header=present", disposition: "attachment; filename=#{filename}"
  end

  def reports_csv_string(reports)
    CSV.generate do |csv|
      csv <<[
       "Created at",
       "Legacy",
       "Caller email",
       "Caller name",
       "Callee name",
       "Date",
       "Summary",
       "No answer notes",
       "Duration",
       "Concerns",
       "Conerns notes",
       "Caller feeling",
       "Callee feeling",
       "Legacy outcome"
      ]
      reports.each do |report|
        csv << [
          report.created_at,
          report.legacy?,
          report.match ? report.match.caller.person.email : report.legacy_caller_email,
          report.match ? report.match.caller.name : report.legacy_caller_name,
          report.match ? report.match.callee.name : report.legacy_callee_name,
          report.date_of_call || report.legacy_date || report.legacy_time_and_date || report.legacy_time,
          report.summary,
          report.no_answer_notes,
          report.humanized_duration || report.legacy_duration,
          report.concerns ? true : false
          report.concerns_notes,
          report.caller_feeling,
          report.callee_feeling,
          report.legacy_outcome
        ]
      end
    end
  end
end
