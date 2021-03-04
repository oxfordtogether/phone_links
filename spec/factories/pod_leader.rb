FactoryBot.define do
  factory :pod_leader, class: PodLeader do
    person factory: :person

    status { PodLeader.statuses.keys.sample }
    status_change_notes { FFaker::Lorem.phrase }
  end
end
