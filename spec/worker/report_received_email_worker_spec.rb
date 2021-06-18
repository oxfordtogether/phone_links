require "rails_helper"

RSpec.describe "ReportReceivedEmailWorker", type: :worker do
  let!(:pod_leader) { create(:pod_leader, report_received_email_updates: true) }
  let!(:pod) { create(:pod, pod_leader: pod_leader) }
  let!(:caller) { FactoryBot.create(:caller) }
  let!(:match) { create(:match, pod: pod, caller: caller, callee: FactoryBot.create(:callee)) }
  let!(:report) { create(:report, match: match )}

  it "only sends email if configuration is correct" do
    params = {report: report, pod: pod, recipient: pod_leader.person}

    expect(ReportReceivedMailer)
        .to receive(:report_received_email)
        .with(report, pod, pod_leader.person)
        .and_return( double("Mailer", :deliver => true) )

    ReportReceivedEmailWorker.new.perform(report.id)
  end

  it "doesn't send email if no pod leader" do
    pod.pod_leader = nil
    pod.save!

    expect(ReportReceivedMailer).not_to receive(:report_received_email)

    ReportReceivedEmailWorker.new.perform(report.id)
  end

  it "doesn't send email if no match" do
    report.match = nil
    report.save!

    expect(ReportReceivedMailer).not_to receive(:report_received_email)

    ReportReceivedEmailWorker.new.perform(report.id)
  end

  it "doesn't send email if pod leader config not set" do
    pod_leader.report_received_email_updates = false
    pod_leader.save!

    expect(ReportReceivedMailer).not_to receive(:report_received_email)

    ReportReceivedEmailWorker.new.perform(report.id)
  end
end
