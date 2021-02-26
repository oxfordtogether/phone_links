FactoryBot.define do
  factory :report do
    created_at { FFaker::Time.between("2019-01-01", Date.today) }
    match { Match.order("RANDOM()").first || create(:match) }
    duration { DURATION_EXAMPLE.sample }
    summary { SUMMARY_EXAMPLE.sample }
    datetime { FFaker::Time.between(created_at - 1.week, created_at) }
    callee_state { CALLEE_STATE_EXAMPLE.sample }

    concerns { rand(3) == 1 }
    concerns_notes { concerns ? CONCERNS_NOTES_EXAMPLE.sample : nil }

    archived_at { rand(5) == 1 ? nil : FFaker::Time.between(datetime, datetime + 1.week) }

    trait :legacy do
      legacy_caller_email { match.caller.person.email }
      legacy_caller_name { match.caller.name }
      legacy_callee_name { match.callee.name }
      legacy_time_and_date { datetime.strftime("%B %-d %Y %H:%M") }
      legacy_time { datetime.strftime("%H:%M") }
      legacy_date { datetime.strftime("%B %-d %Y") }
      legacy_duration { DURATION_EXAMPLE.sample }
      legacy_outcome { OUTCOME_EXAMPLE.sample }
      legacy_pod_id { match.pod.id }
    end
  end
end

DURATION_EXAMPLE ||= [
  "less than 15 minutes",
  "15 to 30 minutes",
  "30 minutes to 1 hour",
  "over one hour",
  "did not answer",
].freeze

SUMMARY_EXAMPLE ||= [
  "We had our usual chat, nothing particular",
  "Jo seemed down at first but perky by the time the call ended",
  "Agreed to meet up as soon as lockdown is over and walk along the thames",
  "We laughed and laughed and laughed",
  "Callee was busy and cut the call short",
].freeze

CALLEE_STATE_EXAMPLE ||= [
  "Great!",
  "Ok",
  "Not great",
].freeze

CONCERNS_NOTES_EXAMPLE ||= [
  "Haven't been able to get in touch for 2 weeks",
  "Still no answer",
  "Callee would like help with her computer",
  "Callee would like a referral to Oxford Together",
  "Calls are very long and I'm struggling to get off the phone",
  nil,
].freeze

OUTCOME_EXAMPLE ||= [
  "Good call",
  "Had a lovely chat",
  "Quite a long call but otherwise really good",
  nil,
].freeze
