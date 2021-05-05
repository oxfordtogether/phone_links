FactoryBot.define do
  factory :match do
    status { Match.statuses.keys.sample }
    status_change_notes { FFaker::Lorem.phrase }

    pod { Pod.order("RANDOM()").first || create(:pod) }
    callee { Callee.order("RANDOM()").first || create(:callee) }
    caller { Caller.order("RANDOM()").first || create(:caller) } # TO DO: doesn't work as expected because caller is a ruby keyword

    report_frequency { rand(2) == 1 ? Match.report_frequencies.keys.sample : nil }
    alerts_paused_until { rand(10) == 1 ? FFaker::Time.between(Date.today - 1.week, Date.today + 1.month) : nil }
  end
end
