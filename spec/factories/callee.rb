FactoryBot.define do
  factory :callee, class: Callee do
    person factory: :person

    active { !(rand(10) == 1) }
    pod { Pod.order("RANDOM()").first || create(:pod) }

    reason_for_referral { FFaker::Lorem.phrase }
    living_arrangements { FFaker::Lorem.phrase }
    additional_needs { FFaker::Lorem.phrase }
    other_information { FFaker::Lorem.phrase }
  end
end
