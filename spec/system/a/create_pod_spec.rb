require "rails_helper"

RSpec.describe "create pod", type: :system do
  let!(:pod_leaders) { create_list(:pod_leader, 10, status: 'active') }
  let!(:pods) do
    (0..6).each do |i|
      create(:pod, pod_leader: pod_leaders[i])
    end

    Pod.all
  end

  it "works" do
    login_as nil

    visit "/a"
    click_on "Pods"
    click_on "New"

    fill_in "Name", with: "ABCD"
    fill_in "Theme", with: "Parents"
    select pod_leaders[7].name, from: "Pod Leader"
    select pod_leaders[9].name, from: "Safeguarding lead"

    expect do
      click_on "Save"
    end.to change { Pod.count }.by(1)

    pod = Pod.last

    expect(page).to have_current_path("/a/pods/#{pod.id}/matches")

    expect(pod.name).to eq("ABCD")
    expect(pod.theme).to eq("Parents")
    expect(pod.pod_leader).to eq(pod_leaders[7])
    expect(pod.safeguarding_lead).to eq(pod_leaders[9].person)
  end

  it "can't create a pod without a safeguarding lead" do
    login_as nil

    visit "/a"
    click_on "Pods"
    click_on "New"

    fill_in "Name", with: "ABCD"
    fill_in "Theme", with: "Parents"
    select pod_leaders[7].name, from: "Pod Leader"

    expect do
      click_on "Save"
    end.to change { Pod.count }.by(0)

    expect(page).to have_content("This field is required")
  end

  it "redirect back to correct page on cancel" do
    login_as nil

    visit "/a/pods/new"

    click_on "Cancel"
    expect(page).to have_current_path("/a/pods")
  end
end
