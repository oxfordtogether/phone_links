FactoryBot.define do
  factory :note, class: Note do
    callee { Callee.order("RANDOM()").first || create(:callee) }
    created_by { Person.order("RANDOM()").first || create(:person) }

    content { FFaker::Lorem.paragraph }
  end
end
