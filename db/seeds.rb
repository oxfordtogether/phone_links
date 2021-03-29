# create some matches and pods
FactoryBot.create_list(:pod_leader, 10)
FactoryBot.create_list(:pod, 10)
FactoryBot.create(:pod, pod_leader: nil)

# create people/roles
FactoryBot.create_list(:admin, 1)
FactoryBot.create_list(:caller, 75)
FactoryBot.create_list(:callee, 150)

# create some people with multiple roles
FactoryBot.create(:admin, person: PodLeader.all.sample.person)
FactoryBot.create(:pod_leader, person: Caller.all.sample.person)

callers = Caller.all
callees = Callee.all
pods = Pod.all
callees.each do |callee|
  FactoryBot.create(:match,
                    caller: callers.filter { |c| c.pod == callee.pod }.sample,
                    callee: callee,
                    pod: callee.pod)
end
# add a couple of callees with multiple matches
callees[0..25].each do |callee|
  FactoryBot.create(:match,
                    caller: callers.filter { |c| c.pod == callee.pod && callee.matches[0].caller != c }.sample,
                    callee: callee,
                    pod: callee.pod)
end

FactoryBot.create_list(:emergency_contact, 150)

# create some reports & notes
FactoryBot.create_list(:report, 100)
FactoryBot.create_list(:report, 200, :legacy)
FactoryBot.create_list(:report, 200, :legacy, match: nil)
FactoryBot.create_list(:note, 500)

# safeguarding concerns
FactoryBot.create_list(:safeguarding_concern, 50)

# referrals
FactoryBot.create_list(:referral, 30)

SearchCache.refresh
