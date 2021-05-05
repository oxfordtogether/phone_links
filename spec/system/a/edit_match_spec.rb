require "rails_helper"

RSpec.describe "edit match", type: :system do
  let!(:caller) { create(:caller) }
  let!(:match) { create(:match, status: "provisional", status_change_notes: "notes", caller: caller) }
  let!(:pods) { create_list(:pod, 10) }

  it "works" do
    login_as nil

    visit "/a/matches/#{match.id}"
    click_on "Edit"

    expect(find_field("match_pod_id").value).to eq match.pod.id.to_s
    expect(find_field("match_status").value).to eq match.status.to_s
    expect(find_field("match_status_change_notes").value).to eq ""

    select pods[1].name, from: "Pod"
    select "Ended", from: "Status"
    fill_in "Status change notes", with: "some note"

    expect do
      click_on "Save"
    end.to change { MatchStatusChange.count }.by(1)

    match.reload

    expect(page).to have_current_path("/a/matches/#{match.id}")

    expect(match.pod.id).to eq(pods[1].id)
    expect(match.status_change_notes).to eq("some note")
    expect(match.ended).to eq(true)
  end

  it "cancels" do
    login_as nil

    visit "/a/matches/#{match.id}/edit"

    click_on "Cancel"
    expect(page).to have_current_path("/a/matches/#{match.id}")
  end
end
