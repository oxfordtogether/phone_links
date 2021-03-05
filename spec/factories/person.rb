FactoryBot.define do
  factory :person, class: Person do
    title { %w[MR MRS MISS MS MX DR PROFESSOR].sample }
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    phone { FFaker::PhoneNumberDE.home_work_phone_number }
    email { "#{first_name.split.join('.')}_#{last_name.split.join('.')}@example.com".downcase }
    address_line_1 { FFaker::AddressUK.street_address }
    address_line_2 { FFaker::AddressUK.secondary_address }
    address_town { FFaker::AddressUK.city }
    address_postcode { FFaker::AddressUK.postcode }

    auth0_id { "auth0|#{(0...18).map { rand(10) }.join}" }

    flag_in_progress { rand(10) == 1 }
    flag_change_datetime { FFaker::Time.between(Date.today - 2.months, Date.today) }
    flag_change_notes { flag_in_progress ? FFaker::Lorem.phrase : nil }

    age_bracket { Person.age_brackets.keys.sample }
  end
end
