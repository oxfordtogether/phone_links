require "rails_helper"

RSpec.describe "create match", type: :system do
  let!(:callers) { create_list(:caller, 10) }
  let!(:callees) { create_list(:callee, 10) }
  let!(:pods) { create_list(:pod, 10) }

  it "works from waitlist page" do
    login_as nil

    visit "/waitlist/provisional_matches"
    click_on "New Match"

    select pods[1].name, from: "Pod"
    select callees[5].name_and_pod, from: "Callee"

    select callers[5].name_pod_capacity, from: "Caller"
    date_picker_fill_in "match_start_date", date: Date.parse("2020-01-01")
    uncheck "Provisional"

    expect do
      click_on "Save"
    end.to change { Match.count }.by(1)

    match = Match.last
    expect(match.pod).to eq(pods[1])
    expect(match.caller).to eq(callers[5])
    expect(match.callee).to eq(callees[5])
    expect(match.start_date.strftime("%Y-%m-%d")).to eq("2020-01-01")
    expect(match.pending).to eq(nil)
  end

  it "works from pod page" do
    login_as nil

    visit "/pods/#{pods[1].id}/matches"
    click_on "New Match"

    expect(find_field("match_pod_id").value).to eq pods[1].id.to_s

    select callees[5].name_and_pod, from: "Callee"
    select callers[5].name_pod_capacity, from: "Caller"
    date_picker_fill_in "match_start_date", date: Date.parse("2020-01-01")
    uncheck "Provisional"

    expect do
      click_on "Save"
    end.to change { Match.count }.by(1)

    match = Match.last
    expect(match.pod).to eq(pods[1])
    expect(match.caller).to eq(callers[5])
    expect(match.callee).to eq(callees[5])
    expect(match.start_date.strftime("%Y-%m-%d")).to eq("2020-01-01")
    expect(match.pending).to eq(nil)
  end

  it "redirect back to correct page on cancel" do
    login_as nil

    visit "/pods/#{pods[1].id}/matches"
    click_on "New Match"
    click_on "Cancel"
    expect(page).to have_current_path("/pods/#{pods[1].id}/matches")

    visit "/waitlist/provisional_matches"
    click_on "New Match"
    click_on "Cancel"
    expect(page).to have_current_path("/waitlist/provisional_matches")
  end
end
