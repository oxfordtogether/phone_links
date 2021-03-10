require "rails_helper"

RSpec.describe "create report", type: :system do
  # create a list of callees, otherwise the created matches will always be the same one
  let!(:callees) { create_list(:callee, 150) }
  # create a caller to be able to create a match
  let!(:caller) { create(:caller) }
  # create a match using the created caller as argument
  let!(:match_1) { create(:match, caller: caller) }
  # create more than one matches because one caller typically has 1 to 3 callees
  let!(:match_2) { create(:match, caller: caller) }
  let!(:match_3) { create(:match, caller: caller) }

  it "works" do
    # set to pas the homepage
    login_as nil
    # will visit the homepage of the caller created in the test
    visit "/c/#{caller.id}"
    click_link href: "/c/#{caller.id}/callees/#{match_2.callee_id}"
    click_on "New Report"
    select match_2.callee_name, from: "Who did you call?"
    date_picker_fill_in "report_date_of_call", date: Date.parse("2020-01-01")
    select "15 - 30 minutes", from: "Length of the call"
    select "Great!", from: "How did the person you're calling feel today"
    select "Very confident", from: "How confident did you feel with the call"
    fill_in "Brief summary of the call", with: "This is a test"
    check "Do you have anything that you would like to discuss with your pod leader?"
    fill_in "Please briefly describe what you would like to discuss with your pod leader", with: "This is a test"

    expect do
      click_on "Submit report"
    end.to change { Report.count }.by(1)

    report = Report.last
    # page is the destination page once clicked on Submit
    # report is the last entry in the Report database.
    expect(page).to have_current_path("/c/#{caller.id}")
    expect(report.match.id).to eq(match_2.id)
    expect(report.date_of_call.strftime("%Y-%m-%d")).to eq("2020-01-01")
    expect(report.duration).to eq(:fifteen_thirty)
    expect(report.callee_state).to eq(:great)
    expect(report.caller_confidence).to eq(:very_confident)
    expect(report.summary).to eq("This is a test")
    expect(report.concerns).to eq(true)
    expect(report.concerns_notes).to eq("This is a test")
  end

  it "redirect back to correct page on cancel" do
    login_as nil
    visit "/c/#{caller.id}/callees/#{match_2.callee_id}"
    click_on "New Report"

    click_on "Cancel"
    expect(page).to have_current_path("/c/#{caller.id}")
  end
end
