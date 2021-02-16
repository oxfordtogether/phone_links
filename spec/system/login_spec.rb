require "rails_helper"

RSpec.describe "login", type: :system do
  let(:admin) { create(:admin, active: true) }
  let(:admin_not_active) { create(:admin, active: false) }

  let(:pod_leader) { create(:pod_leader, active: true) }
  let(:pod_leader_not_active) { create(:pod_leader, active: false) }

  let(:caller) { create(:caller, active: true) }
  let(:caller_not_active) { create(:caller, active: false) }

  let(:person_with_2_roles) do
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

  it "redirects to /login if user isn't logged in" do
    visit "/"
    expect(current_path).to eq("/login")
  end

  describe "as active user: " do
    it "logs in and shows homepage for active admin" do
      login_as admin.person

      visit "/"
      expect(current_path).to eq("/a")
    end
    it "logs in and shows homepage for active pod leader" do
      login_as pod_leader.person

      visit "/"
      expect(current_path).to eq("/pl")
    end
    it "logs in and shows homepage for active caller" do
      login_as caller.person

      visit "/"
      expect(current_path).to eq("/c")
    end
  end

  describe "as non-active user: " do
    it "prevents access for non-active admin" do
      login_as admin_not_active.person

      visit "/"
      expect(current_path).to eq("/invalid_permissions")
    end
    it "prevents access for non-active pod leader" do
      login_as pod_leader_not_active.person

      visit "/"
      expect(current_path).to eq("/invalid_permissions")
    end
    it "prevents access for non-active caller" do
      login_as caller_not_active.person

      visit "/"
      expect(current_path).to eq("/invalid_permissions")
    end
  end

  describe "restricts access:" do
    it "prevents access to areas of site depending on role" do
      login_as admin.person
      visit "/pl"
      expect(current_path).to eq("/invalid_permissions")
      visit "/c"
      expect(current_path).to eq("/invalid_permissions")

      login_as pod_leader.person
      visit "/a"
      expect(current_path).to eq("/invalid_permissions")
      visit "/c"
      expect(current_path).to eq("/invalid_permissions")

      login_as caller.person
      visit "/a"
      expect(current_path).to eq("/invalid_permissions")
      visit "/pl"
      expect(current_path).to eq("/invalid_permissions")
    end
  end

  it "handles user with multiple roles" do
    login_as person_with_2_roles
    visit "/a"
    expect(current_path).to eq("/invalid_permissions")
    visit "/pl"
    expect(current_path).to eq("/pl")
    visit "/c"
    expect(current_path).to eq("/c")
  end

  it "prevents access for non-program participants" do
    login_as nil

    visit "/"
    expect(current_path).to eq("/invalid_permissions")
  end

  it "/invalid_permissions links to logout" do
    login_as admin_not_active.person

    visit "/"
    expect(current_path).to eq("/invalid_permissions")

    click_on "Back"
    expect(current_path).to eq("/logout")
  end
end
