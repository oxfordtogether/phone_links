require "rails_helper"

RSpec.describe "create callee", type: :system do
  let!(:person) { create(:person, first_name: "Tim", last_name: "Thompson") }
  let!(:admin) do
    create(:admin, person: create(:person, first_name: "Tim", last_name: "Jones"))
  end
  let!(:pods) { create_list(:pod, 10) }

  before(:each) do
    SearchCache.refresh
  end

  it "creates new person and callee role" do
    login_as nil

    visit "/a/waitlist/callees"
    click_on "New Callee"
    expect(page).to have_current_path("/a/people/new?role=callee")

    fill_in "First name", with: "Bob"
    fill_in "Last name", with: "Jones"
    fill_in "Phone", with: "12345"

    expect { click_on "Save" }.to change { Person.count }.by(1).and change { Callee.count }.by(1)

    person = Person.last
    callee = Callee.last

    expect(page).to have_current_path("/a/people/#{person.id}/edit/personal_details")

    expect(person.first_name).to eq("Bob")
    expect(person.last_name).to eq("Jones")
    expect(person.phone).to eq("12345")

    expect(person.callee.id).to eq(callee.id)
    expect(person.callee.status).to eq(:waiting_list)
    expect(person.callee.status_change_datetime.strftime("%Y-%m-%d")).to eq(Date.today.strftime("%Y-%m-%d"))
  end

  it "links to person profile" do
    login_as nil

    visit "/a/people/new?role=callee"

    fill_in "Search", with: "Tim"
    first("a", text: "go to profile").click
    expect(page).to have_current_path("/a/people/#{person.id}/events")
  end

  it "redirect back to home page on cancel" do
    login_as nil

    visit "/a/waitlist/callees"
    click_on "New Callee"
    click_on "Cancel"
    expect(page).to have_current_path("/a")
  end
end
