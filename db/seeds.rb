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
(0..150).to_a.each do |_i|
  pod = pods.sample
  FactoryBot.create(:match,
                    caller: callers.filter { |c| c.pod == pod }.sample,
                    callee: callees.filter { |c| c.pod == pod }.sample,
                    pod: pod,
                    pending: rand(10) == 1)
end

# create some reports & notes
FactoryBot.create_list(:report, 100)
FactoryBot.create_list(:report, 400, :legacy)
FactoryBot.create_list(:note, 500)

SearchCache.refresh
