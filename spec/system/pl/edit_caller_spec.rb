require "rails_helper"

RSpec.describe "edit caller", type: :system do
  let!(:pod) { create(:pod) }
  let!(:pod_leader) { create(:pod_leader, pod: pod) }
  let!(:caller) { create(:caller, pod: pod) }

  it "edits status" do
    login_as nil

    visit "/pl/#{pod_leader.id}/people/#{caller.person.id}"
    click_on "Status"
    expect(page).to have_current_path("/pl/#{pod_leader.id}/callers/#{caller.id}/edit/status")

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
end
