FactoryBot.define do
  factory :caller, class: Caller do
    person factory: :person

    active { !(rand(10) == 1) }
    pod { Pod.order("RANDOM()").first || create(:pod) }

    experience { FFaker::Lorem.phrase }
  end
end
