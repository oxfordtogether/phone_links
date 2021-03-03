require "rails_helper"

RSpec.describe "activate match", type: :system do
  let!(:caller) { create(:caller) }
  let!(:match) { create(:match, start_date: nil, end_date: nil, end_reason: nil, end_reason_notes: nil, caller: caller) }
  let!(:pods) { create_list(:pod, 10) }

  it "works" do
    login_as nil

    visit "/a/matches/#{match.id}"
    click_on "Activate match"

    within(".activate-form-buttons") { click_on "Activate match" }

    match.reload

    expect(page).to have_current_path("/a/matches/#{match.id}")

    expect(match.provisional).to eq(false)
    expect(match.start_date.strftime("%Y-%m-%d")).to eq(Date.today.strftime("%Y-%m-%d"))
  end
end
