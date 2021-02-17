require "rails_helper"

RSpec.describe "edit match", type: :system do
  let!(:caller) { create(:caller) }
  let!(:match) { create(:match, end_date: "2020-01-01", end_reason: "CREATED_BY_MISTAKE", end_reason_notes: "Whoops!", pending: true, caller: caller) }
  let!(:pods) { create_list(:pod, 10) }

  it "works" do
    login_as nil

    visit "/a/matches/#{match.id}"
    click_on "Edit"

    expect(find_field("match_pod_id").value).to eq match.pod.id.to_s
    date_picker_expect_value "Start date", date: match.start_date
    date_picker_expect_value "End date", date: match.end_date
    expect(find_field("match_pending").checked?).to eq true
    expect(find_field("match_end_reason").value).to eq match.end_reason
    expect(find_field("match_end_reason_notes").value).to eq match.end_reason_notes

    select pods[1].name, from: "Pod"
    date_picker_fill_in "match_start_date", date: Date.parse("2020-01-01")
    date_picker_fill_in "match_end_date", date: Date.parse("2021-02-22")
    select "Not a fit", from: "End reason"
    fill_in "End reason notes", with: "didn't work"
    uncheck "Provisional"

    click_on "Save"

    match.reload

    expect(page).to have_current_path("/a/matches/#{match.id}")

    expect(match.pod.id).to eq(pods[1].id)
    expect(match.end_reason).to eq("NOT_A_FIT")
    expect(match.end_reason_notes).to eq("didn't work")
    expect(match.start_date.strftime("%Y-%m-%d")).to eq("2020-01-01")
    expect(match.end_date.strftime("%Y-%m-%d")).to eq("2021-02-22")
    expect(match.pending).to eq(nil)
  end

  it "cancels" do
    login_as nil

    visit "/a/matches/#{match.id}/edit"

    click_on "Cancel"
    expect(page).to have_current_path("/a/matches/#{match.id}")
  end
end
