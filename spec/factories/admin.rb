FactoryBot.define do
  factory :admin, class: Admin do
    person factory: :person

    start_date { FFaker::Time.between("2019-01-01", Date.today) }
    end_date { rand(10) == 1 ? FFaker::Time.between(start_date, Date.today) : nil }
    active { !(rand(10) == 1) }
  end
end
