require "rails_helper"

RSpec.describe "multiple roles", type: :system do
  let!(:pod_leader) { create(:pod_leader, status: "active") }
  let!(:person_pl_role) { pod_leader.person }

  let!(:caller) { create(:caller, status: "active", pod: nil) }
  let!(:person_c_role) { caller.person }

  let!(:person_pl_and_c_roles) do
    person = create(:person)
    create(:caller, person: person, status: "active", pod: nil)
    create(:pod_leader, person: person, status: "active")

    person
  end

  let!(:admin) { create(:admin, status: "active") }
  let!(:person_a_role) { admin.person }
  let!(:person_a_and_pl_roles) do
    person = create(:person)
    create(:admin, person: person, status: "active")

    pod = create(:pod, name: "ABC", pod_leader: nil)
    create(:pod_leader, person: person, pods: [pod], status: "active")

    person
  end

  before do
    ENV["BYPASS_AUTH"] = "false"
  end

  after do
    ENV["BYPASS_AUTH"] = "true"
  end

  it "links between admin and pod leader areas for an admin with multiple roles" do
    login_as person_a_role

    expect(page).to have_current_path("/a")
    expect(page).to_not have_content("Pod ABC")

    login_as person_a_and_pl_roles

    expect(page).to have_current_path("/a")
    expect(page).to have_content("Pod ABC")
  end

  it "allows switching between pod leader and callers areas when roles are valid" do
    login_as person_pl_and_c_roles

    expect(current_path).to eq("/pl/pod_leaders/#{person_pl_and_c_roles.pod_leader.id}")

    expect(page).to have_content("Caller's Area")
    click_on "Caller's Area"
    expect(current_path).to eq("/c/callers/#{person_pl_and_c_roles.caller.id}")

    expect(page).to have_content("Pod Leader's Area")
    click_on "Pod Leader's Area"
    expect(current_path).to eq("/pl/pod_leaders/#{person_pl_and_c_roles.pod_leader.id}")
  end

  describe "prevents switching between areas when roles aren't valid" do
    it "as a pod leader" do
      login_as person_pl_role

      # login spec tests that /c/.. area isn't accessible for pod leader & vice versa
      expect(current_path).to eq("/pl/pod_leaders/#{person_pl_role.pod_leader.id}")
      expect(page).not_to have_content("Caller's Area")
    end
    it "as a caller" do
      login_as person_c_role

      expect(page).to have_current_path("/c/callers/#{person_c_role.caller.id}")
      expect(page).not_to have_content("Pod Leader's Area")
    end
  end
end
