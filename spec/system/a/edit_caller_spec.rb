require "rails_helper"

RSpec.describe "edit caller", type: :system do
  let!(:person) { create(:person) }
  let!(:caller) { create(:caller, person: person) }
  let!(:pods) { create_list(:pod, 10) }

  it "shows correct tabs" do
    login_as nil

    visit "/a/people/#{person.id}"
    click_on "Details"
    expect(page).to have_current_path("/a/people/#{person.id}/edit/personal_details")

    expect(page).to have_content("Personal")
    expect(page).to have_content("Contact")
    expect(page).to have_content("Caller experience")
    expect(page).to have_content("Pod")
    expect(page).to have_content("Caller status")
  end

  it "edits experience" do
    login_as nil

    visit "/a/people/#{person.id}"
    click_on "Edit"
    click_on "Caller experience"
    expect(page).to have_current_path("/a/people/#{person.id}/edit/experience")

    expect(find_field("Experience").value).to eq caller.experience

    fill_in "Experience", with: "experience"

    click_on "Save"

    caller.reload
    expect(caller.experience).to eq("experience")
  end

  it "edits status" do
    login_as nil

    visit "/a/people/#{person.id}"
    click_on "Edit"
    click_on "Caller status"
    expect(page).to have_current_path("/a/callers/#{person.caller.id}/edit/status")

    expect(find_field("caller_status").value).to eq caller.status.to_s
    expect(find_field("caller_status_change_notes").value).to eq ""

    select "Left programme", from: "Status"
    fill_in "Status change notes", with: "boo"

    click_on "Save"

    caller.reload
    status_change = RoleStatusChange.last

    expect(caller.status).to eq(:left_programme)
    expect(caller.status_change_notes).to eq("boo")
    expect(caller.status_change_datetime.strftime("%Y-%m-%d")).to eq(Date.today.strftime("%Y-%m-%d"))

    expect(status_change.caller).to eq(caller)
    expect(status_change.status).to eq(:left_programme)
    expect(status_change.notes).to eq("boo")
  end

  it "edits pod membership" do
    login_as nil

    visit "/a/people/#{person.id}"
    click_on "Edit"
    click_on "Pod membership"
    expect(page).to have_current_path("/a/people/#{person.id}/edit/pod_membership")

    expect(find_field("person_caller_attributes_pod_id").value).to eq caller.pod.id.to_s

    select pods[1].name, from: "Pod"

    click_on "Save"

    caller.reload
    expect(caller.pod).to eq(pods[1])
  end
end
