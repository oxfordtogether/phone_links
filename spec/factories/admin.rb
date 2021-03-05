FactoryBot.define do
  factory :admin, class: Admin do
    person factory: :person

    status { Admin.statuses.keys.sample }
    status_change_notes { FFaker::Lorem.phrase }
    status_change_datetime { FFaker::Time.between(Date.today - 1.year, Date.today) }
  end
end
