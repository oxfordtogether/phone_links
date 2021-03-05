require "rails_helper"

RSpec.describe "edit match", type: :system do
  let!(:pod) { create(:pod) }
  let!(:pod_leader) { create(:pod_leader, pod: pod) }
  let!(:caller) { create(:caller) }
  let!(:match) { create(:match, status: "provisional", status_change_notes: "notes", caller: caller) }

  it "works" do
    login_as nil

    visit "/pl/#{pod_leader.id}/matches/#{match.id}"
    click_on "Edit"

    expect(find_field("match_status").value).to eq match.status.to_s
    expect(find_field("match_status_change_notes").value).to eq ""

    select "Ended", from: "Status"
    fill_in "Status change notes", with: "some note"
    click_on "Save"

    match.reload

    expect(page).to have_current_path("/pl/#{pod_leader.id}/matches/#{match.id}")

    expect(match.status_change_notes).to eq("some note")
    expect(match.ended).to eq(true)
  end
end
