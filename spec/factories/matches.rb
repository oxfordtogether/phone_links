FactoryBot.define do
  factory :match do
    pending { rand(5) == 1 }

    callee { Callee.order("RANDOM()").first || create(:callee) }
    caller { Caller.order("RANDOM()").first || create(:caller) } # TO DO: doesn't work
  end
end
