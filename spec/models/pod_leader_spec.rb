require "rails_helper"

RSpec.describe "PodLeader", type: :model do
  let!(:pods) { create_list(:pod, 4, pod_leader: nil) }

  let!(:pod_leader_1) do
    pod_leader = create(:pod_leader, status: "active", pods: pods[0..1])
    pod_supporters = [
      create(:pod_supporter, pod: pods[3], supporter: pod_leader),
    ]
    pod_leader
  end

  let!(:pod_leader_2) { create(:pod_leader, status: "active", pods: [pods[2]]) }

  let!(:pod_leader_3) do
    pod_leader = create(:pod_leader, status: "active", pods: [pods[3]])
    pod_supporters = [
      create(:pod_supporter, pod: pods[0], supporter: pod_leader),
      create(:pod_supporter, pod: pods[2], supporter: pod_leader),
    ]
    pod_leader
  end

  let!(:pod_leader_4) do
    pod_leader = create(:pod_leader, status: "active", pods: [])
    pod_supporters = [
      create(:pod_supporter, pod: pods[1], supporter: pod_leader),
    ]
    pod_leader
  end

  it "evaluates set of pods a pod leader has access to" do
    expect(pod_leader_1.accessible_pod_ids).to eq([pods[0].id, pods[1].id, pods[3].id])
    expect(pod_leader_2.accessible_pod_ids).to eq([pods[2].id])
    expect(pod_leader_3.accessible_pod_ids).to eq([pods[3].id, pods[0].id, pods[2].id])
    expect(pod_leader_4.accessible_pod_ids).to eq([pods[1].id])
  end
end

