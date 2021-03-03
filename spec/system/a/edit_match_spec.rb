require "rails_helper"

RSpec.describe "edit match", type: :system do
  let!(:caller) { create(:caller) }
  let!(:match) { create(:match, status: "provisional", end_reason: "CREATED_BY_MISTAKE", end_reason_notes: "Whoops!", caller: caller) }
  let!(:pods) { create_list(:pod, 10) }

  it "works" do
    login_as nil

    visit "/a/matches/#{match.id}"
    click_on "Edit"

    expect(find_field("match_pod_id").value).to eq match.pod.id.to_s
    expect(find_field("match_status").value).to eq match.status.to_s
    expect(find_field("match_end_reason").value).to eq match.end_reason
    expect(find_field("match_end_reason_notes").value).to eq match.end_reason_notes

    select pods[1].name, from: "Pod"
    select "Ended", from: "Status"
    select "Not a fit", from: "End reason"
    fill_in "End reason notes", with: "didn't work"

    click_on "Save"

    match.reload

    expect(page).to have_current_path("/a/matches/#{match.id}")

    expect(match.pod.id).to eq(pods[1].id)
    expect(match.end_reason).to eq("NOT_A_FIT")
    expect(match.end_reason_notes).to eq("didn't work")
    expect(match.ended).to eq(true)
  end

  it "cancels" do
    login_as nil

    visit "/a/matches/#{match.id}/edit"

    click_on "Cancel"
    expect(page).to have_current_path("/a/matches/#{match.id}")
  end
end
