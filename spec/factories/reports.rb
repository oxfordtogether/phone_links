FactoryBot.define do
  factory :report do
    match { Match.order("RANDOM()").first || create(:match) }
    duration { "MyString" }
    summary { "Call went well" }
    datetime { "2021-02-16" }
    callee_state { "MyString" }
  end
end
