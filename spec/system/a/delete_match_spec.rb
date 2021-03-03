require "rails_helper"

RSpec.describe "delete match", type: :system do
  let!(:caller) { create(:caller) }
  let!(:match) { create(:match, start_date: nil, end_date: nil, end_reason: nil, end_reason_notes: nil, caller: caller) }
  let!(:pods) { create_list(:pod, 10) }

  it "works" do
    login_as nil

    visit "/a/matches/#{match.id}"
    click_on "Activate match"

    click_on "Delete"

    match.reload

    expect(page).to have_current_path("/a/pods/#{match.pod.id}/matches")

    expect(match.provisional).to eq(true)
    expect(match.deleted_at).to_not eq(nil)
    expect(match.start_date).to eq(nil)
  end
end
