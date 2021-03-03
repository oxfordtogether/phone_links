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
    expect(page).to have_content("Status")
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

  it "edits active status" do
    login_as nil

    visit "/a/people/#{person.id}"
    click_on "Edit"
    click_on "Status"
    expect(page).to have_current_path("/a/people/#{person.id}/edit/active")

    active_status = caller.active

    expect(find_field("person_caller_attributes_active").checked?).to eq active_status
    if active_status
      uncheck "person_caller_attributes_active"
    else
      check "person_caller_attributes_active"
    end

    click_on "Save"

    caller.reload
    expect(caller.active).to eq(!active_status ? true : nil)
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
