require "rails_helper"

RSpec.describe "create safeguarding concern", type: :system do
  let!(:pod_1) { create(:pod, pod_leader: nil) }
  let!(:pod_2) { create(:pod, pod_leader: nil) }
  let!(:pod_leader) { create(:pod_leader, pods: [pod_1], status: 'active') }
  let!(:callees) { create_list(:callee, 10, pod: pod_1) }
  let!(:more_callees) { create_list(:callee, 10, pod: pod_2) }

  before do
    ENV["BYPASS_AUTH"] = "false"
  end

  after do
    ENV["BYPASS_AUTH"] = "true"
  end

  it "works" do
    login_as pod_leader.person

    # TO DO
    # visit "/pl/pod_leaders/#{pod_leader.id}"
    # click_on "Safeguarding"
    visit "/pl/pods/#{pod_1.id}/safeguarding_concerns"

    click_on "New"

    within('#safeguarding_concern_person_id') do
      expect(all("option").count).to eq(callees.count + 1)
    end
    select callees[1].name, from: "Who is this concern about?"
    fill_in "Please describe your concern in detail", with: "test"

    expect do
      click_on "Submit"
    end.to change { SafeguardingConcern.count }.by(1).and change { SafeguardingConcernStatusChange.count }.by(1)

    safeguarding_concern = SafeguardingConcern.last

    expect(page).to have_current_path("/pl/pods/#{pod_1.id}/safeguarding_concerns")

    expect(safeguarding_concern.person).to eq(callees[1].person)
    expect(safeguarding_concern.concerns).to eq("test")
    expect(safeguarding_concern.created_by).to eq(pod_leader.person)
    expect(safeguarding_concern.status).to eq(:unread)
    expect(safeguarding_concern.status_changed_at).to_not eq(nil)
    expect(safeguarding_concern.status_changed_notes).to eq(nil)
  end

  it "handles required fields" do
    login_as pod_leader.person

    visit "/pl/pods/#{pod_1.id}/safeguarding_concerns/new"

    expect do
      click_on "Submit"
    end.to change { SafeguardingConcern.count }.by(0).and change { SafeguardingConcernStatusChange.count }.by(0)

    expect(all("p", text: "This field is required").count).to eq(2)

    within('#safeguarding_concern_person_id') do
      expect(all("option").count).to eq(callees.count + 1)
    end
  end

  it "links to safeguarding form" do
    skip "TO DO"
  end
end
