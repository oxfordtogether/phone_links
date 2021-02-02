FactoryBot.define do
  factory :match do
    start_date { FFaker::Time.between("2019-01-01", Date.today) }
    end_date { rand(10) == 1 ? FFaker::Time.between(start_date, Date.today) : nil }
    pending { rand(5) == 1 }

    pod { Pod.order("RANDOM()").first || create(:pod) }
    callee { Callee.order("RANDOM()").first || create(:callee) }
    caller { Caller.order("RANDOM()").first || create(:caller) } # TO DO: doesn't work
  end
end
