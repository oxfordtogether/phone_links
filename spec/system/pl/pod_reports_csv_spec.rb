require "rails_helper"

RSpec.describe "pod reports csv download", type: :system do
  let!(:admin) { create(:admin, status: "active", person: create(:person, email: "admin@test.com", auth0_id: "123")) }
  let!(:pod_leader_1) { create(:pod_leader, pods: [], person: create(:person), status: "active") }
  let!(:pod_leader_2) { create(:pod_leader, pods: [], person: create(:person), status: "active") }
  let!(:caller) { create(:caller, pod: nil, person: create(:person, email: "caller@test.com", auth0_id: "567"), status: "active") }

  let!(:pod_1) { create(:pod, pod_leader: pod_leader_1) }
  let!(:pod_2) { create(:pod, pod_leader: pod_leader_2) }

  before do
    ENV["BYPASS_AUTH"] = "false"
  end

  after do
    ENV["BYPASS_AUTH"] = "true"
    Current.person_id = nil
  end

  it "allows admin to download pod reports csv" do
    login_as admin.person

    visit "/pl/pods/#{pod_1.id}/reporting/pod_reports_csv"
    expect(current_path).to eq("/a")
  end

  it "allows pod leader to download pod reports csv for their pods only" do
    login_as pod_leader_1.person

    visit "/pl/pods/#{pod_1.id}/reporting/pod_reports_csv"
    expect(current_path).to eq("/pl/pods/#{pod_1.id}")

    expect do
      visit "/pl/pods/#{pod_2.id}/reporting/pod_reports_csv"
      page.has_text? "Wait for page to load"
    end.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "allows pod leader to download pod reports csv for their pods only" do
    login_as caller.person

    expect do
      visit "/pl/pods/#{pod_1.id}/reporting/pod_reports_csv"
      page.has_text? "Wait for page to load"
    end.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "doesn't allow random person to download pod reports csv" do
    login_as nil

    visit "/pl/pods/#{pod_1.id}/reporting/pod_reports_csv"
    expect(page).to have_content("Invalid permissions")
  end
end
