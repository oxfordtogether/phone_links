FactoryBot.define do
  factory :admin, class: Admin do
    person factory: :person

    status { Admin.statuses.keys.sample }
    status_change_notes { FFaker::Lorem.phrase }
  end
end
