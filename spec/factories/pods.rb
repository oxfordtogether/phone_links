FactoryBot.define do
  factory :pod do
    sequence(:name) { |n| "#{('A'..'Z').to_a[rand(26)]}#{n}" }
    pod_leader { PodLeader.all.filter { |p| p.pod.nil? }.sample || create(:pod_leader) }
    theme { ["Older people", "Under 30s", "Mental health", "East Oxford", "West Oxford", "Physical illness"].sample }
  end
end
