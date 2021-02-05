FactoryBot.define do
  factory :pod do
    name { FFaker::Color.name }
    pod_leader factory: :pod_leader
    theme { ["Older people", "Under 30s", "Mental health", "East Oxford", "West Oxford", "Physical illness"].sample }
  end
end
