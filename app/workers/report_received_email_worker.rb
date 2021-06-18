class ReportReceivedEmailWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(id)
    report = Report.find(id)

    pod = report&.match&.pod
    pod_leader = pod&.pod_leader

    return unless pod.present? && pod_leader.present?
    return unless pod_leader.report_received_email_updates

    ReportReceivedMailer.report_received_email(report, pod, pod_leader.person).deliver
  end
end
