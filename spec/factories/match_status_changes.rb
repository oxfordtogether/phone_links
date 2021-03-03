FactoryBot.define do
  factory :match_status_change do
    status { MatchStatusChange.statuses.keys.sample }
  end
end
