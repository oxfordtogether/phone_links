FactoryBot.define do
  factory :pod_leader, class: PodLeader do
    person factory: :person

    active { !(rand(10) == 1) }
  end
end
