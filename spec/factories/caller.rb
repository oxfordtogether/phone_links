FactoryBot.define do
  factory :caller, class: Caller do
    person factory: :person

    active { !(rand(10) == 1) }
    pod { Pod.order("RANDOM()").first || create(:pod) }

    experience { FFaker::Lorem.phrase }

    added_to_waiting_list { rand(10) == 1 ? FFaker::Time.between(Date.today - 6.months, Date.today) : nil }
  end
end
