FactoryBot.define do
  factory :caller, class: Caller do
    person factory: :person

    pod { Pod.order("RANDOM()").first || create(:pod) }

    experience { FFaker::Lorem.phrase }

    status { Caller.statuses.keys.sample }
    status_change_notes { FFaker::Lorem.phrase }
  end
end
