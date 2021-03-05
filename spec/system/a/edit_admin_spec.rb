require "rails_helper"

RSpec.describe "edit admin", type: :system do
  let!(:person) { create(:person) }
  let!(:admin) { create(:admin, person: person) }
  let!(:pods) { create_list(:pod, 10) }

  it "shows correct tabs" do
    login_as nil

    visit "/a/people/#{person.id}"
    click_on "Details"
    expect(page).to have_current_path("/a/people/#{person.id}/edit/personal_details")

    expect(page).to have_content("Personal")
    expect(page).to have_content("Contact")
    expect(page).to have_content("Admin status")
  end

  it "edits status" do
    login_as nil

    visit "/a/people/#{person.id}"
    click_on "Edit"
    click_on "Admin status"
    expect(page).to have_current_path("/a/admins/#{person.admin.id}/edit/status")

    expect(find_field("admin_status").value).to eq admin.status.to_s
    expect(find_field("admin_status_change_notes").value).to eq ""

    select "Left programme", from: "Status"
    fill_in "Status change notes", with: "boo"

    click_on "Save"

    admin.reload
    status_change = RoleStatusChange.last

    expect(admin.status).to eq(:left_programme)
    expect(admin.status_change_notes).to eq("boo")
    expect(admin.status_change_datetime.strftime("%Y-%m-%d")).to eq(Date.today.strftime("%Y-%m-%d"))

    expect(status_change.admin).to eq(admin)
    expect(status_change.status).to eq(:left_programme)
    expect(status_change.notes).to eq("boo")
  end
end
