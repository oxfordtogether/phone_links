require "rails_helper"

RSpec.describe "create safeguarding concern", type: :system do
  let!(:pod) { create(:pod) }
  let!(:callees) { create_list(:callee, 10, pod: pod) }
  let!(:caller) { create(:caller, pod: pod, status: "active") }
  let!(:match_1) { create(:match, caller: caller, callee: callees[0], status: 'active') }
  let!(:match_2) { create(:match, caller: caller, callee: callees[1], status: 'active') }

  before do
    ENV["BYPASS_AUTH"] = "false"
  end

  after do
    ENV["BYPASS_AUTH"] = "true"
  end

  it "works" do
    login_as caller.person

    visit "/c/#{caller.id}/safeguarding_concerns/new"

    within('#safeguarding_concern_person_id') do
      expect(all("option").count).to eq(2 + 1)
    end

    select callees[0].name, from: "Who is this concern about?"
    fill_in "Please describe your concern in detail", with: "test"

    expect do
      click_on "Submit"
    end.to change { SafeguardingConcern.count }.by(1).and change { SafeguardingConcernStatusChange.count }.by(1)

    safeguarding_concern = SafeguardingConcern.last

    expect(page).to have_current_path("/c/#{caller.id}")

    expect(safeguarding_concern.person).to eq(callees[0].person)
    expect(safeguarding_concern.concerns).to eq("test")
    expect(safeguarding_concern.created_by).to eq(caller.person)
    expect(safeguarding_concern.status).to eq(:unread)
    expect(safeguarding_concern.status_changed_at).to_not eq(nil)
    expect(safeguarding_concern.status_changed_notes).to eq(nil)
  end

  it "handles required fields" do
    login_as caller.person

    visit "/c/#{caller.id}/safeguarding_concerns/new"

    expect do
      click_on "Submit"
    end.to change { SafeguardingConcern.count }.by(0).and change { SafeguardingConcernStatusChange.count }.by(0)

    expect(all("p", text: "This field is required").count).to eq(2)

    within('#safeguarding_concern_person_id') do
      expect(all("option").count).to eq(2 + 1)
    end
  end

  it "links to safeguarding form" do
    skip "TO DO"
  end
end
