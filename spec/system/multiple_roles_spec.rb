require "rails_helper"

RSpec.describe "multiple roles", type: :system do
  let!(:pod_leader) { create(:pod_leader, active: true) }
  let!(:person_pl_role) { pod_leader.person }

  let!(:caller) { create(:caller, active: true) }
  let!(:person_c_role) { caller.person }

  let!(:person_pl_and_c_roles) do
    person = create(:person)
    create(:caller, person: person, active: true)
    create(:pod_leader, person: person, active: true)

    person
  end

  before do
    ENV["BYPASS_AUTH"] = "false"
  end

  after do
    ENV["BYPASS_AUTH"] = "true"
  end

  it "allows switching between pod leader and callers areas when roles are valid" do
    login_as person_pl_and_c_roles

    expect(current_path).to eq("/pl/#{person_pl_and_c_roles.pod_leader.id}")

    expect(page).to have_content("Switch to caller's area")
    click_on "Switch to caller's area"
    expect(current_path).to eq("/c/#{person_pl_and_c_roles.caller.id}")

    expect(page).to have_content("Switch to pod leader's area")
    click_on "Switch to pod leader's area"
    expect(current_path).to eq("/pl/#{person_pl_and_c_roles.pod_leader.id}")
  end

  it "prevents switching between areas when roles aren't valid" do
    login_as person_pl_role

    # login spec tests that /c/.. area isn't accessible for pod leader & vice versa

    expect(current_path).to eq("/pl/#{person_pl_role.pod_leader.id}")
    expect(page).not_to have_content("Switch to caller's area")

    login_as person_c_role

    expect(current_path).to eq("/c/#{person_c_role.caller.id}")
    expect(page).not_to have_content("Switch to pod leader's area")
  end
end