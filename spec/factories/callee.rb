FactoryBot.define do
  factory :callee, class: Callee do
    person factory: :person

    pod { Pod.order("RANDOM()").first || create(:pod) }

    reason_for_referral { FFaker::Lorem.phrase }
    living_arrangements { FFaker::Lorem.phrase }
    additional_needs { FFaker::Lorem.phrase }
    other_information { FFaker::Lorem.phrase }
    call_frequency { FFaker::Lorem.phrase }
    languages_notes { FFaker::Lorem.phrase }

    status { Callee.statuses.keys.sample }
    status_change_notes { FFaker::Lorem.phrase }
    status_change_datetime { FFaker::Time.between(Date.today - 1.year, Date.today) }
  end
end
