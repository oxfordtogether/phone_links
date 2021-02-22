require "rails_helper"

RSpec.describe "create report", type: :system do
  let!(:caller) { create(:caller) }
  let!(:match_1) { create(:match, caller: caller) }
  # can create more than one matches
  let!(:match_2) { create(:match, caller: caller) }
  let!(:match_3) { create(:match, caller: caller) }

  it "works" do
    login_as nil

    visit "/c/#{caller.id}"
    click_on "Reports"
    click_on "New"
    select match_2.names, from: "Match"
    select "Great!", from: "How was the call?"
    date_picker_fill_in "report_datetime", date: Date.parse("2020-01-01")
    select "12", from: "report[datetime(4i)]"
    select "05", from: "report[datetime(5i)]"
    select "15 to 30 minutes", from: "Call duration"
    fill_in "Summary", with: "This is a test"

    expect do
      click_on "Submit report"
    end.to change { Report.count }.by(1)

    report = Report.last

    expect(page).to have_current_path("/c/#{caller.id}/reports")
    expect(report.match.id).to eq(match_2.id)
    expect(report.callee_state).to eq("Great!")
    expect(report.duration).to eq("5 to 30 minutes")
    expect(report.summary).to eq("This is a test")
  end

  it "redirect back to correct page on cancel" do
    login_as nil

    visit "/c/reports/new"

    click_on "Cancel"
    expect(page).to have_current_path("/c")
  end
end
