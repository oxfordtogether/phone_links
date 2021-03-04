FactoryBot.define do
  factory :match do
    status { Match.statuses.keys.sample }
    status_change_notes { FFaker::Lorem.phrase }

    pod { Pod.order("RANDOM()").first || create(:pod) }
    callee { Callee.order("RANDOM()").first || create(:callee) }
    caller { Caller.order("RANDOM()").first || create(:caller) } # TO DO: doesn't work as expected because caller is a ruby keyword
  end
end
