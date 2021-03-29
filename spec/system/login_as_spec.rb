require "rails_helper"

RSpec.describe "login as", type: :system do
  let!(:admin) { create(:admin, person: create(:person, email: "admin@test.com", auth0_id: "123"), status: "active") }
  let!(:pod) { create(:pod, pod_leader: nil) }
  let!(:pod_leader) { create(:pod_leader, person: create(:person, email: "pod_leader@test.com", auth0_id: "234"), pods: [pod], status: "active")}
  let!(:pod_leader_1) { create(:pod_leader, person: create(:person, email: "pod_leader_1@test.com", auth0_id: "345"), pods: [], status: "active")}
  let!(:caller) { create(:caller, person: create(:person, email: "caller@test.com", auth0_id: "456"), status: "active") }
  let!(:caller_1) { create(:caller, person: create(:person, email: "caller_1@test.com", auth0_id: "567"), status: "active") }

  before do
    ENV["BYPASS_AUTH"] = "false"
  end

  after do
    ENV["BYPASS_AUTH"] = "true"
  end

  it "allows admin to login as pod leader" do
    login_as admin.person

    expect(current_path).to eq("/a")
    expect(page).to have_content("Hi #{admin.name}")

    click_on "Admin"
    click_on "Pod Leaders"

    click_link href: "/pl/pod_leaders/#{pod_leader.id}"

    expect(page).to have_content("Hi #{pod_leader.name}")
    expect(page).to have_content("Reports")
    expect(current_path).to eq("/pl/pods/#{pod_leader.pods[0].id}")

    click_on "Back to Admin"

    expect(current_path).to eq("/a")
    expect(page).to have_content("Hi #{admin.name}")
  end

  it "allows admin to login as caller" do
    login_as admin.person

    expect(current_path).to eq("/a")
    expect(page).to have_content("Hi #{admin.name}")

    click_on "Admin"
    click_on "Callers"

    click_link href: "/c/callers/#{caller.id}"

    expect(current_path).to eq("/c/callers/#{caller.id}")
    expect(page).to have_content("Hi #{caller.name}")

    click_on "Back to Admin"

    expect(current_path).to eq("/a")
    expect(page).to have_content("Hi #{admin.name}")
  end

  it "hides back to links for pod leaders" do
    login_as pod_leader.person

    expect(page).to have_content("Hi #{pod_leader.name}")
    expect(page).to have_content("Reports")
    expect(current_path).to eq("/pl/pods/#{pod_leader.pods[0].id}")

    expect(page).to_not have_content("Back to Admin")
  end

  it "hides back to links for callers" do
    login_as caller.person

    expect(page).to have_content("Hi #{caller.name}")
    expect(current_path).to eq("/c/callers/#{caller.id}")

    expect(page).to_not have_content("Back to Admin")
  end
end
