require "rails_helper"
require "sidekiq/testing"

RSpec.describe "send email to pod leader when report received", type: :system do
  let!(:pod_leader) { create(:pod_leader, report_received_email_updates: true) }
  let!(:pod) { create(:pod, pod_leader: pod_leader) }
  let!(:caller) { FactoryBot.create(:caller) }
  let!(:match) { create(:match, pod: pod, caller: caller, callee: FactoryBot.create(:callee)) }

  it "kicks off job to send email when report created" do
    login_as nil

    visit "/c/matches/#{match.id}/reports/new"

    date_picker_fill_in "report_date_of_call", date: Date.parse("2020-01-01")
    select "15 - 30 minutes", from: "Length of the call"
    find("#report_callee_feeling_great").click
    find("#report_caller_feeling_awful").click
    fill_in "Brief summary of the call", with: "summary"

    expect do
      click_on "Submit report"
    end.to change { Report.count }.by(1).and change(ReportReceivedEmailWorker.jobs, :size).by(1)
  end
end
