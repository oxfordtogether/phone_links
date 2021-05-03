require "rails_helper"

RSpec.describe "edit callee", type: :system do
  let!(:pod) { create(:pod) }
  let!(:pod_leader) { create(:pod_leader, pods: [pod]) }
  let!(:callee) { create(:callee, pod: pod) }

  it "edits status" do
    login_as nil

    visit "/pl/people/#{callee.person.id}"
    click_on "Status"
    expect(page).to have_current_path("/pl/callees/#{callee.id}/status")

    expect(find_field("callee_status").value).to eq callee.status.to_s
    expect(find_field("callee_status_change_notes").value).to eq ""

    select "Left programme", from: "Status"
    fill_in "Status change notes", with: "boo"

    click_on "Save"

    callee.reload
    status_change = RoleStatusChange.last

    expect(callee.status).to eq(:left_programme)
    expect(callee.status_change_notes).to eq("boo")
    expect(callee.status_change_datetime.strftime("%Y-%m-%d")).to eq(Date.today.strftime("%Y-%m-%d"))

    expect(status_change.callee).to eq(callee)
    expect(status_change.status).to eq(:left_programme)
    expect(status_change.notes).to eq("boo")
  end

  it "edits summary" do
    login_as nil

    visit "/pl/people/#{callee.person.id}"
    click_on "Details"
    expect(page).to have_current_path("/pl/people/#{callee.person.id}/edit/summary")

    expect(find_field("Summary").value).to eq callee.summary || ""

    fill_in "Summary", with: "notes"

    click_on "Save"

    callee.reload

    expect(callee.summary).to eq("notes")
  end
end
