FactoryBot.define do
  factory :emergency_contact, class: EmergencyContact do
    callee { Callee.order("RANDOM()").first || create(:callee) }

    name { FFaker::Name.name }
    contact_details { "#{FFaker::PhoneNumberDE.home_work_phone_number}, #{FFaker::PhoneNumberDE.home_work_phone_number}" }
    relationship { %w[Neighbour Friend Daughter GP].sample }
  end
end
