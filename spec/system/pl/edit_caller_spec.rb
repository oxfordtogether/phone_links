require "rails_helper"

RSpec.describe "edit caller", type: :system do
  let!(:pod) { create(:pod) }
  let!(:pod_leader) { create(:pod_leader, pods: [pod]) }
  let!(:caller) { create(:caller, pod: pod) }

  it "edits status" do
    login_as nil

    visit "/pl/people/#{caller.person.id}"
    click_on "Status"
    expect(page).to have_current_path("/pl/callers/#{caller.id}/status")

    expect(find_field("caller_status").value).to eq caller.status.to_s
    expect(find_field("caller_status_change_notes").value).to eq ""

    select "Left programme", from: "Status"
    fill_in "Status change notes", with: "boo"

    expect do
      click_on "Save"
    end.to change { RoleStatusChange.count }.by(1)

    caller.reload
    status_change = RoleStatusChange.last

    expect(caller.status).to eq(:left_programme)
    expect(caller.status_change_notes).to eq("boo")
    expect(caller.status_change_datetime.strftime("%Y-%m-%d")).to eq(Date.today.strftime("%Y-%m-%d"))

    expect(status_change.caller).to eq(caller)
    expect(status_change.status).to eq(:left_programme)
    expect(status_change.notes).to eq("boo")
  end

  it "edits check in frequency" do
    login_as nil

    visit "/pl/people/#{caller.person.id}"
    click_on "Details"
    expect(page).to have_current_path("/pl/callers/#{caller.id}/details")

    expect(find_field("Check-in frequency").value).to eq caller.check_in_frequency.to_s || ""

    select "Every 2 months", from: "Check-in frequency"

    expect do
      click_on "Save"
    end.to change { RoleStatusChange.count }.by(0)

    caller.reload

    expect(caller.check_in_frequency).to eq(:every_2_months)
  end
end
