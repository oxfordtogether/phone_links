FactoryBot.define do
  factory :person, class: Person do
    title { %w[MR MRS MISS MS MX DR PROFESSOR].sample }
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    phone { FFaker::PhoneNumberDE.home_work_phone_number }
    email { "#{first_name.split.join('.')}_#{last_name.split.join('.')}@example.com".downcase }

    auth0_id { "auth0|#{(0...18).map { rand(10) }.join}" }
  end
end
