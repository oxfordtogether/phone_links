require "rails_helper"

RSpec.describe "home", type: :system do
  let!(:pod_leader_no_pod) { create(:pod_leader, pods: []) }
  let!(:pod_leader_one_pod) { create(:pod_leader, pods: [create(:pod)]) }
  let!(:pod_leader_two_pods) { create(:pod_leader, pods: [create(:pod), create(:pod)]) }

  it "shows helpful message if no pods" do
    login_as nil

    visit "pl/pod_leaders/#{pod_leader_no_pod.id}"

    expect(page).to have_content("You aren't an active pod leader.")
  end

  it "redirects to pod if only one pod" do
    login_as nil

    visit "pl/pod_leaders/#{pod_leader_one_pod.id}"
    expect(page).to have_current_path("/pl/pods/#{pod_leader_one_pod.pods[0].id}")
  end

  it "lists pods if more than one pod" do
    login_as nil

    visit "pl/pod_leaders/#{pod_leader_two_pods.id}"
    expect(page).to have_content(pod_leader_two_pods.pods[0].name)
    expect(page).to have_content(pod_leader_two_pods.pods[1].name)
  end
end
