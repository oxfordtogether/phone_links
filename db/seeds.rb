# create some matches and pods
FactoryBot.create_list(:pod_leader, 10)
FactoryBot.create_list(:pod, 10)
FactoryBot.create(:pod, pod_leader: nil)

# create people/roles
FactoryBot.create_list(:caller, 75)
FactoryBot.create_list(:callee, 150)
FactoryBot.create_list(:admin, 1)

# create some people with multiple roles
FactoryBot.create(:admin, person: PodLeader.all.sample.person)
FactoryBot.create(:pod_leader, person: Caller.all.sample.person)

callers = Caller.all
(0..150).to_a.each do |_i|
  # callees should only have one active match
  FactoryBot.create(:match,
                    caller: callers.sample,
                    callee: Callee.with_matches.all.filter { |c| c.active_matches.size == 0 }.sample,
                    pending: rand(10) == 1)
end

SearchCache.refresh
