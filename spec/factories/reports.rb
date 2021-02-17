FactoryBot.define do
  factory :report do
    match { Match.order("RANDOM()").first || create(:match) }
    duration { DURATION_EXAMPLE.sample }
    summary { SUMMARY_EXAMPLE.sample }
    # datetime { FFaker::Time.between("2019-01-01", Date.today) }
    datetime { FFaker::Time.datetime }
    callee_state { CALLEE_STATE_EXAMPLE.sample }
  end
end

DURATION_EXAMPLE ||= [
  "less than 15 minutes",
  "15 to 30 minutes",
  "30 minutes to 1 hour",
  "Over one hour",
  "Did not answer",
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
