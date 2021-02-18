FactoryBot.define do
  factory :callee, class: Callee do
    person factory: :person

    active { rand(10) != 1 }
    pod { Pod.order("RANDOM()").first || create(:pod) }

    reason_for_referral { FFaker::Lorem.phrase }
    living_arrangements { FFaker::Lorem.phrase }
    additional_needs { FFaker::Lorem.phrase }
    other_information { FFaker::Lorem.phrase }

    flag_in_progress { rand(4) == 1 }
    flag_updated_at { FFaker::Time.between(Date.today - 2.months, Date.today) }
    flag_updated_by_id { flag_in_progress ? (Admin.order("RANDOM()").first&.person&.id || create(:admin).person.id) : nil }
    flag_note { flag_in_progress ? FFaker::Lorem.phrase : nil }
  end
end
