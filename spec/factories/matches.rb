FactoryBot.define do
  factory :match do
    start_date { FFaker::Time.between("2019-01-01", Date.today) }
    end_date { rand(10) == 1 ? FFaker::Time.between(start_date, Date.today) : nil }
    pending { rand(5) == 1 }

    end_reason { end_date.present? ? %w[NOT_A_FIT CALLEE_DECEASED CALLEE_LEFT_PROGRAM CALLER_LEFT_PROGRAM CREATED_BY_MISTAKE OTHER].sample : nil }
    end_reason_notes { end_date.present? ? FFaker::Lorem.phrase : nil }

    pod { Pod.order("RANDOM()").first || create(:pod) }
    callee { Callee.order("RANDOM()").first || create(:callee) }
    caller { Caller.order("RANDOM()").first || create(:caller) } # TO DO: doesn't work as expected because caller is a ruby keyword
  end
end
