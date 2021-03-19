require "rails_helper"

RSpec.describe "createx safeguarding concern", type: :system do
  let!(:callees) { create_list(:callee, 10) }

  it "works" do
    login_as nil

    visit "/a"
    click_on "Safeguarding"
    click_on "New"

    select callees[7].name, from: "Who is this concern about?"
    fill_in "Please describe your concern in detail", with: "test"

    expect do
      click_on "Submit"
    end.to change { SafeguardingConcern.count }.by(1).and change { SafeguardingConcernStatusChange.count }.by(1)

    safeguarding_concern = SafeguardingConcern.last

    expect(page).to have_current_path("/a/safeguarding_concerns")

    expect(safeguarding_concern.person).to eq(callees[7].person)
    expect(safeguarding_concern.concerns).to eq("test")
    expect(safeguarding_concern.created_by).to eq(Person.first)
    expect(safeguarding_concern.status).to eq(:unread)
    expect(safeguarding_concern.status_changed_at).to_not eq(nil)
    expect(safeguarding_concern.status_changed_notes).to eq(nil)
  end

  it "handles required fields" do
    login_as nil

    visit "/a"
    click_on "Safeguarding"
    click_on "New"

    expect do
      click_on "Submit"
    end.to change { SafeguardingConcern.count }.by(0).and change { SafeguardingConcernStatusChange.count }.by(0)

    expect(all("p", text: "This field is required").count).to eq(2)
  end
end
