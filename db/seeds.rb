# create people/roles
FactoryBot.create_list(:caller, 75)
FactoryBot.create_list(:callee, 150)
FactoryBot.create_list(:pod_leader, 10)
FactoryBot.create_list(:admin, 1)

# create some people with multiple roles
FactoryBot.create(:admin, person: PodLeader.all.sample.person)
FactoryBot.create(:pod_leader, person: Caller.all.sample.person)
