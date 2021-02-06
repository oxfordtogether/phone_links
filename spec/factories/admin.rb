FactoryBot.define do
  factory :admin, class: Admin do
    person factory: :person

    active { !(rand(10) == 1) }
  end
end
