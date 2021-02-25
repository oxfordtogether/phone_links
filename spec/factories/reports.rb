FactoryBot.define do
  factory :report do
    created_at { FFaker::Time.between("2019-01-01", Date.today) }
    match { Match.order("RANDOM()").first || create(:match) }
    duration { DURATION_EXAMPLE.sample }
    summary { SUMMARY_EXAMPLE.sample }
    datetime { FFaker::Time.between(created_at - 1.week, created_at) }
    callee_state { CALLEE_STATE_EXAMPLE.sample }

    archived_at { rand(5) == 1 ? nil : FFaker::Time.between(datetime, datetime + 1.week) }
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
