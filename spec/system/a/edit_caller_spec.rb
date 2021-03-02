require "rails_helper"

RSpec.describe "edit caller", type: :system do
  let!(:person) { create(:person) }
  let!(:caller) { create(:caller, person: person) }
  let!(:pods) { create_list(:pod, 10) }

  it "shows correct tabs" do
    login_as nil

    visit "/a/people/#{person.id}"
    click_on "Details"
    expect(page).to have_current_path("/a/people/#{person.id}/edit/personal_details")

    expect(page).to have_content("Personal")
    expect(page).to have_content("Contact")
    expect(page).to have_content("Experience")
  end

  it "edits experience" do
    login_as nil

    visit "/a/people/#{person.id}"
    click_on "Edit"
    click_on "Experience"
    expect(page).to have_current_path("/a/people/#{person.id}/edit/experience")

    expect(find_field("Experience").value).to eq caller.experience

    fill_in "Experience", with: "experience"

    click_on "Save"

    caller.reload
    expect(caller.experience).to eq("experience")
  end
end
