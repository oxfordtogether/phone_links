require "rails_helper"

RSpec.describe "create match", type: :system do
  let!(:pod) { create(:pod) }
  let!(:pod_leader) { create(:pod_leader, pods: [pod]) }
  let!(:callers) { create_list(:caller, 10, pod: pod, status: "active") }
  let!(:callees) { create_list(:callee, 10, pod: pod, status: "active") }

  it "works" do
    login_as nil

    visit "/pl/pods/#{pod.id}/matches"
    click_on "New provisional match"

    select callees[5].name, from: "Callee"
    select callers[5].name, from: "Caller"
    fill_in "Notes", with: "some note"

    expect do
      click_on "Save"
    end.to change { Match.count }.by(1).and change { MatchStatusChange.count }.by(1)

    match = Match.last
    expect(match.pod.id).to eq(pod.id)
    expect(match.caller).to eq(callers[5])
    expect(match.callee).to eq(callees[5])
    expect(match.status_change_notes).to eq("some note")
    expect(match.provisional).to eq(true)
  end

  it "prevents a duplicate match being created" do
    caller = create(:caller, pod: pod)
    callee = create(:callee, pod: pod)
    match = create(:match, caller: caller, callee: callee, pod: pod)

    visit "/pl/pods/#{pod.id}/matches/new"
    select callee.name, from: "Callee"
    select caller.name, from: "Caller"

    click_on "Save"

    expect(page).to have_content("A match for this caller and callee pair already exists")
  end
end
