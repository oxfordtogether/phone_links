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
    expect(page).to have_content("Pod leader status")
  end

  it "edits status" do
    login_as nil

    visit "/a/people/#{person.id}"
    click_on "Edit"
    click_on "Pod leader status"
    expect(page).to have_current_path("/a/pod_leaders/#{person.pod_leader.id}/edit/status")

    expect(find_field("pod_leader_status").value).to eq pod_leader.status.to_s
    expect(find_field("pod_leader_status_change_notes").value).to eq ""

    select "Left programme", from: "Status"
    fill_in "Status change notes", with: "boo"

    click_on "Save"

    pod_leader.reload
    status_change = RoleStatusChange.last

    expect(pod_leader.status).to eq(:left_programme)
    expect(pod_leader.status_change_notes).to eq("boo")
    expect(pod_leader.status_change_datetime.strftime("%Y-%m-%d")).to eq(Date.today.strftime("%Y-%m-%d"))

    expect(status_change.pod_leader).to eq(pod_leader)
    expect(status_change.status).to eq(:left_programme)
    expect(status_change.notes).to eq("boo")
  end
end
