require "rails_helper"

RSpec.describe "create pod", type: :system do
  let!(:pod_leaders) { create_list(:pod_leader, 10) }
  let!(:pods) do
    (0..6).each do |i|
      create(:pod, pod_leader: pod_leaders[i])
    end

    Pod.all
  end

  it "works" do
    login_as nil

    visit "/"
    click_on "Pods"
    click_on "New"

    fill_in "Name", with: "ABCD"
    fill_in "Theme", with: "Parents"
    expect(find("#pod_pod_leader_id").all("option").length).to eq(3 + 1)
    select pod_leaders[7].name, from: "Pod Leader"

    expect do
      click_on "Save"
    end.to change { Pod.count }.by(1)

    pod = Pod.last

    expect(page).to have_current_path("/pods/#{pod.id}/matches")

    expect(pod.name).to eq("ABCD")
    expect(pod.theme).to eq("Parents")
    expect(pod.pod_leader).to eq(pod_leaders[7])
  end

  it "redirect back to correct page on cancel" do
    login_as nil

    visit "/pods/new"

    click_on "Cancel"
    expect(page).to have_current_path("/pods")
  end
end
