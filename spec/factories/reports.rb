FactoryBot.define do
  factory :report do
    duration { "MyString" }
    summary { "MyText" }
    datetime { "2021-02-16" }
    callee_state { "MyString" }
  end
end
