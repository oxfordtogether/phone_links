require "rails_helper"

RSpec.describe "edit pod leader", type: :system do
  let!(:person) { create(:person) }
  let!(:pod_leader) { create(:pod_leader, person: person) }
  let!(:pods) { create_list(:pod, 10) }

  it "shows correct tabs" do
    login_as nil

    visit "/a/people/#{person.id}"
    click_on "Details"
    expect(page).to have_current_path("/a/people/#{person.id}/edit/personal_details")

    expect(page).to have_content("Personal")
    expect(page).to have_content("Contact")
    expect(page).to have_content("Status")
  end

  it "edits active status" do
    login_as nil

    visit "/a/people/#{person.id}"
    click_on "Edit"
    click_on "Status"
    expect(page).to have_current_path("/a/people/#{person.id}/edit/active")

    active_status = pod_leader.active

    expect(find_field("person_pod_leader_attributes_active").checked?).to eq active_status
    if active_status
      uncheck "person_pod_leader_attributes_active"
    else
      check "person_pod_leader_attributes_active"
    end

    click_on "Save"

    pod_leader.reload
    expect(pod_leader.active).to eq(!active_status ? true : nil)
  end
end
