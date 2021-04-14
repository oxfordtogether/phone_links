require "rails_helper"

RSpec.describe "home", type: :system do
  let!(:pod_leader_no_pod) { create(:pod_leader, pods: []) }
  let!(:pod_leader_one_pod) { create(:pod_leader, pods: [create(:pod)]) }
  let!(:pod_leader_two_pods) { create(:pod_leader, pods: [create(:pod), create(:pod)]) }

  let!(:pod_leader_supports_one_pod) do
    pod = create(:pod, pod_leader: nil)
    pod_leader = create(:pod_leader, pods: [])
    create(:pod_supporter, pod: pod, supporter: pod_leader)

    pod_leader
  end

  let!(:pod_leader_supports_two_pods) do
    pods = create_list(:pod, 2, pod_leader: nil)
    pod_leader = create(:pod_leader, pods: [])

    create(:pod_supporter, pod: pods[0], supporter: pod_leader)
    create(:pod_supporter, pod: pods[1], supporter: pod_leader)

    pod_leader
  end

  let!(:pod_leader_supports_and_leads) do
    pods = create_list(:pod, 3, pod_leader: nil)
    pod_leader = create(:pod_leader, pods: [pods[0], pods[1]])

    create(:pod_supporter, pod: pods[2], supporter: pod_leader)

    pod_leader
  end

  it "shows helpful message if no pods" do
    login_as nil

    visit "pl/pod_leaders/#{pod_leader_no_pod.id}"

    expect(page).to have_content("You aren't an active pod leader.")
  end

  describe "redirects to pod if only one pod" do
    it "works for pod leader" do
      login_as nil

      visit "pl/pod_leaders/#{pod_leader_one_pod.id}"
      expect(page).to have_current_path("/pl/pods/#{pod_leader_one_pod.pods[0].id}")
    end

    it "works for pod supporter" do
      login_as nil

      visit "pl/pod_leaders/#{pod_leader_supports_one_pod.id}"
      expect(page).to have_current_path("/pl/pods/#{pod_leader_supports_one_pod.pod_supporters[0].pod.id}")
    end
  end

  describe "lists pods if more than one pod" do
    it "works for pod leader" do
      login_as nil

      visit "pl/pod_leaders/#{pod_leader_two_pods.id}"
      expect(page).to have_content(pod_leader_two_pods.pods[0].name)
      expect(page).to have_content(pod_leader_two_pods.pods[1].name)
    end

    it "works for pod supporter" do
      login_as nil

      visit "pl/pod_leaders/#{pod_leader_supports_two_pods.id}"
      expect(page).to have_content(pod_leader_supports_two_pods.pod_supporters[0].pod.name)
      expect(page).to have_content(pod_leader_supports_two_pods.pod_supporters[1].pod.name)
    end

    it "works for pod leader that leads and supporter" do
      login_as nil

      visit "pl/pod_leaders/#{pod_leader_supports_and_leads.id}"
      expect(page).to have_content(pod_leader_supports_and_leads.pods[0].name)
      expect(page).to have_content(pod_leader_supports_and_leads.pods[1].name)
      expect(page).to have_content(pod_leader_supports_and_leads.pod_supporters[0].pod.name)
    end
  end
end
