class DemoSiteDataSeeder
  def initialize; end

  def empty_db
    PersonFlagChange.delete_all
    MatchStatusChange.delete_all
    RoleStatusChange.delete_all
    Event.delete_all

    Report.delete_all
    Match.delete_all
    Note.delete_all

    EmergencyContact.delete_all
    Callee.delete_all
    Admin.delete_all
    Caller.delete_all

    Pod.delete_all
    PodLeader.delete_all

    Person.delete_all
  end

  def seed
    # pod and pod leaders
    FactoryBot.create_list(:pod_leader, 10)
    FactoryBot.create(:pod_leader,
                      person: FactoryBot.create(:person, auth0_id: nil, first_name: "Paula", last_name: "PodLeader", email: "paula_podleader@teztr.com"),
                      status: "active")

    FactoryBot.create_list(:pod, 10)
    FactoryBot.create(:pod, pod_leader: nil)

    # admins
    FactoryBot.create_list(:admin, 2)
    FactoryBot.create(:admin,
                      person: FactoryBot.create(:person, auth0_id: nil, first_name: "Agatha", last_name: "Admin", email: "agatha_admin@teztr.com"),
                      status: "active")

    # callers
    FactoryBot.create_list(:caller, 75)
    FactoryBot.create(:caller,
                      person: FactoryBot.create(:person, auth0_id: nil, first_name: "Clare", last_name: "Caller", email: "clare_caller@teztr.com"),
                      status: "active")

    # callees
    FactoryBot.create_list(:callee, 150)

    # create some people with multiple roles
    FactoryBot.create(:admin, person: PodLeader.all.sample.person)
    FactoryBot.create(:pod_leader, person: Caller.all.sample.person)

    # matches
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

    SearchCache.refresh
  end
end
