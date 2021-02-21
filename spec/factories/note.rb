FactoryBot.define do
  factory :note, class: Note do
    callee { Callee.order("RANDOM()").first || create(:callee) }
    created_by { Person.order("RANDOM()").first || create(:person) }

    content { FFaker::Lorem.paragraph }
    deleted_at { rand(20) == 1 ? FFaker::Time.between(Date.today - 2.years, Date.today) : nil }
  end
end
