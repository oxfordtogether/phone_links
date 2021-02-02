FactoryBot.define do
  factory :pod do
    name { FFaker::Color.name }
    pod_leader factory: :pod_leader
  end
end
