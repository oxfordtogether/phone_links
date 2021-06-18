# Preview all emails at http://localhost:3000/rails/mailers
class ReportReceivedMailerPreview < ActionMailer::Preview
  def new_report_received_email

    person = FactoryBot.create(:person, email: "test@test.com")
    pod_leader = FactoryBot.create(:pod_leader, person: person)
    pod = FactoryBot.create(:pod, pod_leader: pod_leader)
    caller = FactoryBot.create(:caller)
    match = FactoryBot.create(:match, pod: pod, caller: caller, callee: FactoryBot.create(:callee))
    report = FactoryBot.create(:report, match: match)

    recipient = pod.pod_leader.person

    ReportReceivedMailer.report_received_email(report, pod, recipient)
  end
end
