require "rails_helper"

RSpec.describe "login", type: :system do
  let(:admin) { create(:admin, status: "active", person: create(:person, email: "admin@test.com", auth0_id: "123")) }
  let(:admin_no_auth0) { create(:admin, person: create(:person, email: "admin_no_auth@test.com", auth0_id: nil), status: "active") }
  let(:admin_not_active) { create(:admin, person: create(:person, email: "admin_not_active@test.com", auth0_id: "234"), status: "left_programme") }

  let(:pod_leader) { create(:pod_leader, person: create(:person, email: "pod_leader@test.com", auth0_id: "345"), status: "active") }
  let(:pod_leader_not_active) { create(:pod_leader, person: create(:person, email: "pod_leader_not_active@test.com", auth0_id: "456"), status: "left_programme") }

  let(:caller) { create(:caller, person: create(:person, email: "caller@test.com", auth0_id: "567"), status: "active") }
  let(:caller_not_active) { create(:caller, person: create(:person, email: "caller_not_active@test.com", auth0_id: "789"), status: "left_programme") }

  let(:callee) { create(:callee, status: "active") }

  let(:person_with_2_roles) do
    person = create(:person, email: "person_with_2_roles@test.com", auth0_id: "987")
    create(:caller, person: person, status: "active")
    create(:pod_leader, person: person, status: "active")

    person
  end

  before do
    ENV["BYPASS_AUTH"] = "false"
  end

  after do
    ENV["BYPASS_AUTH"] = "true"
    Current.person_id = nil
  end

  it "redirects to /login if user isn't logged in" do
    visit "/"
    expect(current_path).to eq("/login")
  end

  describe "sets auth0 id if email verified" do
    it "handles unverified email" do
      expect(admin_no_auth0.person.auth0_id).to eq(nil)

      login_as admin_no_auth0.person, email_verified: false

      visit "/"
      expect(current_path).to eq("/unverified_email")

      admin_no_auth0.reload
      expect(admin_no_auth0.person.auth0_id).to eq(nil)
    end

    it "handles unverified email for person with auth0 id" do
      # if we already have an auth0 id, then access is allowed
      login_as admin.person, email_verified: false

      visit "/"
      expect(current_path).to eq("/a")
    end

    it "handles updating auth0_id" do
      expect(admin_no_auth0.person.auth0_id).to eq(nil)

      login_as admin_no_auth0.person, email_verified: true

      visit "/"
      expect(current_path).to eq("/a")

      admin_no_auth0.reload
      expect(admin_no_auth0.person.auth0_id).to_not eq(nil)
    end
  end

  it "handles badly formatted email" do
    person = admin_no_auth0.person

    # set badly formatted email in db, but login with well formatted email
    person.email = " Test@Test.com "
    person.save!

    person.email = "test@test.com"
    login_as person

    visit "/"
    expect(current_path).to eq("/a")
  end

  it "handles missing emails in db" do
    create(:person, email: nil)
    person = admin_no_auth0.person

    login_as person

    visit "/"
    expect(current_path).to eq("/a")
  end

  describe "works for active user" do
    it "logs in and shows homepage for active admin" do
      login_as admin.person

      visit "/"
      expect(current_path).to eq("/a")
    end
    it "logs in and shows homepage for active pod leader" do
      login_as pod_leader.person

      visit "/"
      expect(current_path).to eq("/pl/pod_leaders/#{pod_leader.id}")
    end
    it "logs in and shows homepage for active caller" do
      login_as caller.person

      visit "/"
      expect(current_path).to eq("/c/callers/#{caller.id}")
    end
  end

  describe "when an active user becomes inactive" do
    it "logs them out immediately (admin)" do
      login_as admin.person

      visit "/"
      expect(current_path).to eq("/a")

      admin.update(status: :left_programme)

      visit "/"
      expect(current_path).to eq("/invalid_permissions_for_app")
    end

    it "logs them out immediately (pod leader)" do
      login_as pod_leader.person

      visit "/"
      expect(current_path).to eq("/pl/pod_leaders/#{pod_leader.id}")

      pod_leader.update(status: :left_programme)

      visit "/"
      expect(current_path).to eq("/invalid_permissions_for_app")
    end

    it "logs them out immediately (admin)" do
      login_as caller.person

      visit "/"
      expect(current_path).to eq("/c/callers/#{caller.id}")

      caller.update(status: :left_programme)

      visit "/"
      expect(current_path).to eq("/invalid_permissions_for_app")
    end
  end

  describe "restricts access" do
    it "allows admin to access whole site" do
      login_as admin.person
      visit "/pl/pod_leaders/#{pod_leader.id}"
      expect(current_path).to eq("/pl/pod_leaders/#{pod_leader.id}")
      visit "/c/callers/#{caller_not_active.id}"
      expect(current_path).to eq("/c/callers/#{caller_not_active.id}")
    end

    it "restricts access to areas of site for pod leaders" do
      login_as pod_leader.person

      visit "/a"
      expect(current_path).to eq("/invalid_permissions_for_page")

      expect do
        visit "/pl/pod_leaders/#{pod_leader_not_active.id}"
        page.has_text? "Wait for page to load"
      end.to raise_error(ActiveRecord::RecordNotFound)

      expect do
        visit "/c/callers/#{caller.id}"
        page.has_text? "Wait for page to load"
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "restricts access to areas of site for callers" do
      login_as caller.person

      visit "/a"
      expect(current_path).to eq("/invalid_permissions_for_page")

      expect do
        visit "/pl/pod_leaders/#{pod_leader.id}"
        page.has_text? "Wait for page to load"
      end.to raise_error(ActiveRecord::RecordNotFound)

      expect do
        visit "/c/callers/#{caller_not_active.id}"
        page.has_text? "Wait for page to load"
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  it "handles user with multiple roles" do
    login_as person_with_2_roles

    visit "/a"
    expect(current_path).to eq("/invalid_permissions_for_page")

    visit "/pl/pod_leaders/#{person_with_2_roles.pod_leader.id}"
    expect(current_path).to eq("/pl/pod_leaders/#{person_with_2_roles.pod_leader.id}")

    expect do
      visit "/pl/pod_leaders/#{pod_leader.id}"
      page.has_text? "Wait for page to load"
    end.to raise_error(ActiveRecord::RecordNotFound)

    visit "/c/callers/#{person_with_2_roles.caller.id}"
    expect(current_path).to eq("/c/callers/#{person_with_2_roles.caller.id}")

    expect do
      visit "/c/callers/#{caller.id}"
      page.has_text? "Wait for page to load"
    end.to raise_error(ActiveRecord::RecordNotFound)
  end

  describe "prevents access" do
    it "prevents access for non-active admin" do
      login_as admin_not_active.person

      visit "/"
      expect(current_path).to eq("/invalid_permissions_for_app")
    end
    it "prevents access for non-active pod leader" do
      login_as pod_leader_not_active.person

      visit "/"
      expect(current_path).to eq("/invalid_permissions_for_app")
    end
    it "prevents access for non-active caller" do
      login_as caller_not_active.person

      visit "/"
      expect(current_path).to eq("/invalid_permissions_for_app")
    end
    it "prevents access for callees" do
      login_as callee.person

      visit "/"
      expect(current_path).to eq("/invalid_permissions_for_app")
    end
    it "prevents access for non-program participants" do
      login_as nil

      visit "/"
      expect(current_path).to eq("/invalid_permissions_for_app")
    end
  end

  describe "handles routes that don't exist" do
    it "routes don't exist" do
      login_as admin.person

      expect do
        visit "/pl"
        page.has_text? "Wait for page to load"
      end.to raise_error(ActionController::RoutingError)

      expect do
        visit "/c"
        page.has_text? "Wait for page to load"
      end.to raise_error(ActionController::RoutingError)
    end
    it "invalid namespaced id" do
      login_as admin.person

      expect do
        visit "/pl/pod_leaders/1000"
        page.has_text? "Wait for page to load"
      end.to raise_error(ActiveRecord::RecordNotFound)

      expect do
        visit "/c/callers/1000"
        page.has_text? "Wait for page to load"
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "error pages" do
    it "/invalid_permissions_for_app links to logout" do
      login_as admin_not_active.person

      visit "/"
      expect(current_path).to eq("/invalid_permissions_for_app")

      click_on "Back"
      expect(current_path).to eq("/logout")
    end
    it "/invalid_permissions_for_page links to homepage" do
      login_as pod_leader.person

      visit "/a"
      expect(current_path).to eq("/invalid_permissions_for_page")

      click_on "Back"
      page.has_text? "Hi #{pod_leader.name}"
      expect(current_path).to eq("/pl/pod_leaders/#{pod_leader.id}")
    end
    it "/page_does_not_exist links to homepage" do
      login_as admin.person

      visit "/page_does_not_exist"

      click_on "Back"
      page.has_text? "Hi #{admin.name}"
      expect(current_path).to eq("/a")
    end
  end
end
