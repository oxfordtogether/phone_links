FactoryBot.define do
  factory :report do
    created_at { FFaker::Time.between("2019-01-01", Date.today) }
    match { Match.order("RANDOM()").first || create(:match) }
    duration { Report.durations.keys.sample }
    summary { SUMMARY_EXAMPLE.sample }
    date_of_call { FFaker::Time.between(created_at - 1.week, created_at) }
    callee_state { Report.callee_states.keys.sample }
    caller_confidence { Report.caller_confidences.keys.sample }

    concerns { rand(3) == 1 }
    concerns_notes { concerns ? CONCERNS_NOTES_EXAMPLE.sample : nil }

    archived_at { rand(5) == 1 ? nil : FFaker::Time.between(date_of_call, date_of_call + 1.week) }

    trait :legacy do
      legacy_caller_name { match.present? ? match.caller.name : "#{FFaker::Name.first_name} #{FFaker::Name.last_name}" }
      legacy_caller_email { match.present? ? match.caller.person.email : "#{legacy_caller_name}@example.com" }
      legacy_callee_name { match ? match.callee.name : "#{FFaker::Name.first_name} #{FFaker::Name.last_name}" }
      legacy_time_and_date { date_of_call.strftime("%B %-d %Y %H:%M") }
      legacy_time { date_of_call.strftime("%H:%M") }
      legacy_date { date_of_call.strftime("%B %-d %Y") }
      legacy_duration { DURATION_EXAMPLE.sample }
      legacy_outcome { OUTCOME_EXAMPLE.sample }
      legacy_pod_id { match.present? ? match.pod.id : (Pod.order("RANDOM()").first.id || create(:pod).id) }
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
