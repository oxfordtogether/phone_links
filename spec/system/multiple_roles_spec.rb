require "rails_helper"

RSpec.describe "multiple roles", type: :system do
  let!(:pod_leader) { create(:pod_leader, status: "active") }
  let!(:person_pl_role) { pod_leader.person }

  let!(:caller) { create(:caller, status: "active") }
  let!(:person_c_role) { caller.person }

  let!(:person_pl_and_c_roles) do
    person = create(:person)
    create(:caller, person: person, status: "active")
    create(:pod_leader, person: person, status: "active")

    person
  end

  let!(:admin) { create(:admin, status: "active") }
  let!(:person_a_role) { admin.person }
  let!(:person_a_and_pl_roles) do
    person = create(:person)
    create(:admin, person: person, status: "active")
    create(:pod_leader, person: person, pod: create(:pod, name: "ABC"), status: "active")

    person
  end

  before do
    ENV["BYPASS_AUTH"] = "false"
  end

  after do
    ENV["BYPASS_AUTH"] = "true"
  end

  it "links between admin and pod leader areas for an admin with mutliple roles" do
    login_as person_a_role

    expect(current_path).to eq("/a")
    expect(page).to_not have_content("Pod ABC")

    login_as person_a_and_pl_roles

    expect(current_path).to eq("/a")
    expect(page).to have_content("Pod ABC")
  end

  it "allows switching between pod leader and callers areas when roles are valid" do
    skip "TO DO"
    login_as person_pl_and_c_roles

    expect(current_path).to eq("/pl/#{person_pl_and_c_roles.pod_leader.id}")

    expect(page).to have_content("Caller's Area")
    click_on "Caller's Area"
    expect(current_path).to eq("/c/#{person_pl_and_c_roles.caller.id}")

    expect(page).to have_content("Pod Leader's Area")
    click_on "Pod Leader's Area"
    expect(current_path).to eq("/pl/#{person_pl_and_c_roles.pod_leader.id}")
  end

  it "prevents switching between areas when roles aren't valid" do
    login_as person_pl_role

    # login spec tests that /c/.. area isn't accessible for pod leader & vice versa

    expect(current_path).to eq("/pl/#{person_pl_role.pod_leader.id}")
    expect(page).not_to have_content("Caller's Area")

    login_as person_c_role

    expect(current_path).to eq("/c/#{person_c_role.caller.id}")
    expect(page).not_to have_content("Pod Leader's Area")
  end
end
