# Preview all emails at http://localhost:3000/rails/mailers/report_received
class ReportReceivedMailerPreview < ActionMailer::Preview
  def new_report_received_email
    report = FactoryBot.create(:report)
    pod = report.match.pod
    recipient = pod.pod_leader.person
    ReportReceivedMailer.with(report: report, pod: pod, recipient: recipient).report_received_email
  end
end
