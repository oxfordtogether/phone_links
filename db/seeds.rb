# create people/roles
FactoryBot.create_list(:caller, 75)
FactoryBot.create_list(:callee, 150)
FactoryBot.create_list(:pod_leader, 10)
FactoryBot.create_list(:admin, 1)

# create some people with multiple roles
FactoryBot.create(:admin, person: PodLeader.all.sample.person)
FactoryBot.create(:pod_leader, person: Caller.all.sample.person)

# create some matches and pods
FactoryBot.create_list(:pod, 10)
FactoryBot.create(:pod, pod_leader: nil)

callers = Caller.all
(0..100).to_a.each do |_i|
  FactoryBot.create(:match, caller: callers.sample)
end

SearchCache.refresh
