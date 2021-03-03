FactoryBot.define do
  factory :match do
    status { Match.statuses.keys.sample }

    end_reason { status == "ended" ? %w[NOT_A_FIT CALLEE_DECEASED CALLEE_LEFT_PROGRAM CALLER_LEFT_PROGRAM CREATED_BY_MISTAKE OTHER].sample : nil }
    end_reason_notes { status == "ended" ? FFaker::Lorem.phrase : nil }

    pod { Pod.order("RANDOM()").first || create(:pod) }
    callee { Callee.order("RANDOM()").first || create(:callee) }
    caller { Caller.order("RANDOM()").first || create(:caller) } # TO DO: doesn't work as expected because caller is a ruby keyword
  end
end
