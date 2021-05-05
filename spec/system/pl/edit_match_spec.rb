require "rails_helper"

RSpec.describe "edit match", type: :system do
  let!(:pod) { create(:pod) }
  let!(:pod_leader) { create(:pod_leader, pods: [pod]) }
  let!(:caller) { create(:caller) }
  let!(:match) { create(:match, status: "provisional", status_change_notes: "notes", caller: caller) }

  it "updates status" do
    login_as nil

    visit "/pl/matches/#{match.id}"
    click_on "Edit"

    expect(find_field("match_status").value).to eq match.status.to_s
    expect(find_field("match_status_change_notes").value).to eq ""

    select "Ended", from: "Status"
    fill_in "Status change notes", with: "some note"

    expect do
      click_on "Save"
    end.to change { MatchStatusChange.count }.by(1)

    match.reload

    expect(page).to have_current_path("/pl/matches/#{match.id}")

    expect(match.status_change_notes).to eq("some note")
    expect(match.ended).to eq(true)
  end

  it "updates alert details" do
    login_as nil

    visit "/pl/matches/#{match.id}"
    click_on "Edit"
    click_on "Alerts"

    expect(find_field("Expected report frequency").value).to eq match.report_frequency.to_s || ""

    select "weekly", from: "Expected report frequency"
    fill_in "match_alerts_paused_until(3i)", with: "03"
    fill_in "match_alerts_paused_until(2i)", with: "02"
    fill_in "match_alerts_paused_until(1i)", with: "2021"

    expect do
      click_on "Save"
    end.to change { MatchStatusChange.count }.by(0)

    match.reload

    expect(page).to have_current_path("/pl/matches/#{match.id}")

    expect(match.report_frequency.to_s).to eq("7")
    expect(match.alerts_paused_until.strftime("%Y-%m-%d")).to eq("2021-02-03")
  end
end
