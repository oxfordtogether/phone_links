require "rails_helper"

RSpec.describe "edit safeguarding concern", type: :system do
  let!(:person) { create(:person) }
  let!(:safeguarding_concern) { create(:safeguarding_concern, status: "unread") }

  it "works" do
    login_as nil

    visit "/a"
    click_on "Safeguarding"
    find("tr", text: safeguarding_concern.person.name).click

    expect(page).to have_current_path("/a/safeguarding_concerns/#{safeguarding_concern.id}")

    expect(find_field("Status").value).to eq "unread"
    expect(find_field("Notes").value).to eq ""

    select "in progress", from: "Status"
    fill_in "Notes", with: "test"

    expect do
      click_on "Save"
    end.to change { SafeguardingConcern.count }.by(0).and change { SafeguardingConcernStatusChange.count }.by(1)

    safeguarding_concern.reload

    expect(page).to have_current_path("/a/safeguarding_concerns/#{safeguarding_concern.id}")

    expect(safeguarding_concern.status).to eq(:in_progress)
    expect(safeguarding_concern.status_changed_notes).to eq("test")
  end
end
