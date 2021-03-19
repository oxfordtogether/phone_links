FactoryBot.define do
  factory :safeguarding_concern do
    person { Callee.order("RANDOM()")&.first&.person || create(:callee).person }
    created_by { Caller.order("RANDOM()")&.first&.person || create(:caller).person }

    concerns { CONCERNS_EXAMPLES.sample }
    status { SafeguardingConcern.statuses.keys.sample }
    status_changed_at { FFaker::Time.between(Date.today - 2.weeks, Date.today) }
    status_changed_notes { STATUS_CHANGED_NOTES_EXAMPLES.sample }
  end

  CONCERNS_EXAMPLES = [
    "I haven't been able to contact Alice for 2 weeks",
    "Bob is running out of food",
    "I was on a call to Claire and she sounded different from normal",
    "David is struggling and could use some more support urgently",
  ]

  STATUS_CHANGED_NOTES_EXAMPLES = [
    "No further action needed",
    "Have followed up with next of kin",
    "Waiting to hear back from GP",
    "Test submission",
    "Referred on for more support",
  ]
end
