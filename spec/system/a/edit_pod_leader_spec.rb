require "rails_helper"

RSpec.describe "edit pod leader", type: :system do
  let!(:person) { create(:person) }
  let!(:pod_leader) { create(:pod_leader, person: person) }
  let!(:pods) { create_list(:pod, 10) }

  it "shows correct tabs" do
    login_as nil

    visit "/a/people/#{person.id}"
    click_on "Details"
    expect(page).to have_current_path("/a/people/#{person.id}/edit/personal_details")

    expect(page).to have_content("Personal")
    expect(page).to have_content("Contact")
  end
end
