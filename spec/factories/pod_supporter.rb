FactoryBot.define do
  factory :pod_supporter, class: PodSupporter do
    supporter { PodLeader.order("RANDOM()").first || create(:pod_leader) }
    pod { Pod.order("RANDOM()").first || create(:pod) }
  end
end
