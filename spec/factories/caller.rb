FactoryBot.define do
  factory :caller, class: Caller do
    person factory: :person

    pod { Pod.order("RANDOM()").first || create(:pod) }

    experience { FFaker::Lorem.phrase }
    languages_notes { FFaker::Lorem.phrase }
    check_in_frequency { Caller.check_in_frequencies.keys.sample }

    status { Caller.statuses.keys.sample }
    status_change_notes { FFaker::Lorem.phrase }
    status_change_datetime { FFaker::Time.between(Date.today - 1.year, Date.today) }

    pod_whatsapp_membership { [true, false, nil].sample }
  end
end
