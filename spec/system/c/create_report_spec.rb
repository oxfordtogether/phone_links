require "rails_helper"

RSpec.describe "create report", type: :system do
  let!(:caller) { create(:caller, status: "active", person: create(:person, auth0_id: '123', email: "caller@test.com")) }
  let!(:callee) { create(:callee, status: "active") }

  let!(:match) { create(:match, caller: caller, callee: callee, status: "active") }

  it "works" do
    login_as nil

    visit "/c/callers/#{caller.id}"

    click_link href: "/c/matches/#{match.id}"

    click_on "New report"

    date_picker_fill_in "report_date_of_call", date: Date.parse("2020-01-01")

    select "15 - 30 minutes", from: "Length of the call"
    find("#report_callee_feeling_great").click
    find("#report_caller_feeling_awful").click
    fill_in "Brief summary of the call", with: "summary"
    check "Do you have anything that you would like to discuss with your pod leader?"

    expect(page).to have_content("Please briefly describe what you would like to discuss with your pod leader")
    fill_in "Please briefly describe what you would like to discuss with your pod leader", with: "concern notes"

    expect do
      click_on "Submit report"
    end.to change { Report.count }.by(1)

    report = Report.last
    expect(page).to have_current_path("/c/matches/#{match.id}")

    expect(report.match.id).to eq(match.id)
    expect(report.date_of_call.strftime("%Y-%m-%d")).to eq("2020-01-01")
    expect(report.duration).to eq(:fifteen_thirty)
    expect(report.callee_feeling).to eq(:great)
    expect(report.caller_feeling).to eq(:awful)
    expect(report.summary).to eq("summary")
    expect(report.concerns).to eq(true)
    expect(report.concerns_notes).to eq("concern notes")
  end

  it "works if call not answered" do
    login_as nil

    visit "/c/callers/#{caller.id}"

    click_link href: "/c/matches/#{match.id}"
    click_on "New report"

    date_picker_fill_in "report_date_of_call", date: Date.parse("2020-01-01")
    select "I did not get through", from: "Length of the call"
    expect(page).to_not have_content("How did #{callee.person.first_name} seem today?")
    expect(page).to_not have_content("How do you feel the call went?")
    expect(page).to_not have_content("Brief summary of the call")
    fill_in "Please add any comments you have here", with: "comments"

    expect do
      click_on "Submit report"
    end.to change { Report.count }.by(1)

    report = Report.last
    expect(page).to have_current_path("/c/matches/#{match.id}")

    expect(report.match.id).to eq(match.id)
    expect(report.date_of_call.strftime("%Y-%m-%d")).to eq("2020-01-01")
    expect(report.duration).to eq(:no_answer)
    expect(report.callee_feeling).to eq(nil)
    expect(report.caller_feeling).to eq(nil)
    expect(report.summary).to eq(nil)
    expect(report.no_answer_notes).to eq("comments")
    expect(report.concerns).to eq(nil)
    expect(report.concerns_notes).to eq("")
  end

  it "redirect back to correct page on cancel" do
    login_as nil
    visit "/c/matches/#{match.id}"
    click_on "New report"

    click_on "Cancel"
    expect(page).to have_current_path("/c/matches/#{match.id}")
  end

  it "prevents access to page for invalid match" do
    ENV["BYPASS_AUTH"] = "false"

    login_as caller.person

    match.status = "ended"
    match.save!

    expect do
      visit "/c/matches/#{match.id}/reports/new"
      page.has_text? "Wait for page to load"
    end.to raise_error(ActiveRecord::RecordNotFound)

    match_1 = create(:match, caller: create(:caller))
    expect do
      visit "/c/matches/#{match_1.id}/reports/new"
      page.has_text? "Wait for page to load"
    end.to raise_error(ActiveRecord::RecordNotFound)

    ENV["BYPASS_AUTH"] = "true"
  end
end
