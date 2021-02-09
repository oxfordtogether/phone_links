require "rails_helper"

RSpec.describe "edit match", type: :system do
  let!(:caller) { create(:caller) }
  let!(:match) { create(:match, end_date: nil, pending: true, caller: caller) }

  it "works" do
    login_as nil

    visit "/matches/#{match.id}"
    click_on "Edit"

    date_picker_expect_value "Start date", date: match.start_date
    date_picker_expect_value "End date", date: match.end_date
    expect(find_field("match_pending").checked?).to eq true

    date_picker_fill_in "match_start_date", date: Date.parse("2020-01-01")
    date_picker_fill_in "match_end_date", date: Date.parse("2021-02-22")
    uncheck "Provisional"

    click_on "Save"

    match.reload

    expect(page).to have_current_path("/matches/#{match.id}")

    expect(match.start_date.strftime("%Y-%m-%d")).to eq("2020-01-01")
    expect(match.end_date.strftime("%Y-%m-%d")).to eq("2021-02-22")
    expect(match.pending).to eq(nil)
  end

  it "cancels" do
    login_as nil

    visit "/matches/#{match.id}/edit"

    click_on "Cancel"
    expect(page).to have_current_path("/matches/#{match.id}")
  end
end
