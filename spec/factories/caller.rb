FactoryBot.define do
  factory :caller, class: Caller do
    person factory: :person

    start_date { FFaker::Time.between("2019-01-01", Date.today) }
    end_date { rand(10) == 1 ? FFaker::Time.between(start_date, Date.today) : nil }
    active { !(rand(10) == 1) }
    pod { Pod.order("RANDOM()").first || create(:pod) }

    experience { FFaker::Lorem.phrase }
  end
end
