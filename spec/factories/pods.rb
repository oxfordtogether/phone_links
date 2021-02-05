FactoryBot.define do
  factory :pod do
    name { ("A".."Z").to_a[rand(26)] + ("A".."Z").to_a[rand(26)] }
    pod_leader factory: :pod_leader
    theme { ["Older people", "Under 30s", "Mental health", "East Oxford", "West Oxford", "Physical illness"].sample }
  end
end
