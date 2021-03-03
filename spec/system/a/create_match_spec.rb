require "rails_helper"

RSpec.describe "create match", type: :system do
  let!(:callers) { create_list(:caller, 10, active: true) }
  let!(:callees) { create_list(:callee, 10, active: true) }
  let!(:pods) { create_list(:pod, 10) }

  it "works from waitlist page" do
    login_as nil

    visit "/a/waitlist/provisional_matches"
    click_on "New provisional match"

    select pods[1].name, from: "Pod"
    select callees[5].name_and_pod, from: "Callee"

    select callers[5].name_pod_capacity, from: "Caller"

    expect do
      click_on "Save"
    end.to change { Match.count }.by(1)

    match = Match.last
    expect(match.pod.id).to eq(pods[1].id)
    expect(match.caller).to eq(callers[5])
    expect(match.callee).to eq(callees[5])
    expect(match.provisional).to eq(true)
  end

  it "works from pod page" do
    login_as nil

    visit "/a/pods/#{pods[1].id}/matches"
    click_on "New provisional match"

    expect(find_field("match_pod_id").value).to eq pods[1].id.to_s

    select callees[5].name_and_pod, from: "Callee"
    select callers[5].name_pod_capacity, from: "Caller"

    expect do
      click_on "Save"
    end.to change { Match.count }.by(1)

    match = Match.last
    expect(match.pod.id).to eq(pods[1].id)
    expect(match.caller).to eq(callers[5])
    expect(match.callee).to eq(callees[5])
    expect(match.provisional).to eq(true)
  end

  it "redirect back to correct page on cancel" do
    login_as nil

    visit "/a/pods/#{pods[1].id}/matches"
    click_on "New provisional match"
    click_on "Cancel"
    expect(page).to have_current_path("/a/pods/#{pods[1].id}/matches")

    visit "/a/waitlist/provisional_matches"
    click_on "New provisional match"
    click_on "Cancel"
    expect(page).to have_current_path("/a/waitlist/provisional_matches")
  end
end
