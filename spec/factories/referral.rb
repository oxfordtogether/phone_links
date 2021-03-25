FactoryBot.define do
  factory :referral, class: Referral do

    submitted_at { FFaker::Time.between(Date.today - 1.month, Date.today) }

    referrer_type { Referral.referrer_types.keys.sample }
    referrer_organisation { FFaker::Company.name }
    referrer_full_name { FFaker::Name.first_name + " " +  FFaker::Name.last_name}
    referrer_phone { FFaker::PhoneNumberDE.home_work_phone_number }
    referrer_email { "#{referrer_full_name}@example.com" }

    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    phone { FFaker::PhoneNumberDE.home_work_phone_number }

    address_line_1 { FFaker::AddressUK.street_address }
    address_line_2 { FFaker::AddressUK.secondary_address }
    address_town { FFaker::AddressUK.city }
    address_postcode { FFaker::AddressUK.postcode }

    age_bracket { Referral.age_brackets.keys.sample }
    date_of_birth { FFaker::Time.between("1920-01-01", "1960-01-01") }

    reason_for_referral { FFaker::Lorem.phrase }
    additional_needs { FFaker::Lorem.phrase }
    other_information { FFaker::Lorem.phrase }
    other_support { FFaker::Lorem.phrase }
    languages { FFaker::Lorem.phrase }

    emergency_contact_name { FFaker::Name.name }
    emergency_contact_details { "#{FFaker::PhoneNumberDE.home_work_phone_number}, #{FFaker::PhoneNumberDE.home_work_phone_number}" }
    emergency_contact_relationship { %w[Neighbour Friend Daughter GP].sample }

    status { Referral.statuses.keys.sample }
    notes { FFaker::Lorem.phrase }
    status_changed_at { FFaker::Time.between(submitted_at, Date.today) }

    confirm_consent { true }
    confirm_data_shared { true }
    confirm_data_protection { true }
  end
end
