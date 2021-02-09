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

    pod = pods[2]

    visit "/"
    click_on "Pods"
    find("tr", text: pod.name).click
    click_on "Edit"

    expect(find_field("Name").value).to eq pod.name
    expect(find_field("Theme").value).to eq pod.theme
    expect(find_field("Pod Leader").value).to eq pod.pod_leader.id.to_s

    fill_in "Name", with: "ABCD"
    fill_in "Theme", with: "Parents"
    select pod_leaders[7].name, from: "Pod Leader"

    expect do
      click_on "Save"
    end.to change { Pod.count }.by(0)

    pod.reload

    expect(page).to have_current_path("/pods/#{pod.id}/matches")

    expect(pod.name).to eq("ABCD")
    expect(pod.theme).to eq("Parents")
    expect(pod.pod_leader).to eq(pod_leaders[7])
  end

  it "cancels" do
    login_as nil

    visit "/pods/#{pods[0].id}/edit"

    click_on "Cancel"
    expect(page).to have_current_path("/pods/#{pods[0].id}/matches")
  end
end
