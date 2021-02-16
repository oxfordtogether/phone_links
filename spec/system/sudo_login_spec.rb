require "rails_helper"

RSpec.describe "login", type: :system do
  let(:admin) { create(:admin, active: true) }
  let(:pod_leader) { create(:pod_leader, active: true) }
  let(:caller) { create(:caller, active: true) }

  before do
    ENV["BYPASS_AUTH"] = "false"
  end

  after do
    ENV["BYPASS_AUTH"] = "true"
  end

  it "works for an admin" do
    login_as admin.person

    visit "/a/sudo_login/person/#{pod_leader.person.id}"
    expect(current_path).to eq("/pl")
    expect(page).to have_content("Hi #{pod_leader.name}")

    visit "/a"
    expect(current_path).to eq("/invalid_permissions")
    visit "/c"
    expect(current_path).to eq("/invalid_permissions")

    visit "/pl"
    click_on "Logout"
    expect(current_path).to eq("/logout")
  end

  it "doesn't work for a non-admin" do
    login_as pod_leader.person
    visit "/a/sudo_login/person/#{caller.person.id}"
    expect(current_path).to eq("/invalid_permissions")

    login_as caller.person
    visit "/a/sudo_login/person/#{admin.person.id}"
    expect(current_path).to eq("/invalid_permissions")
  end
end
