require "rails_helper"

RSpec.describe "create caller", type: :system do
  let!(:person) { create(:person, first_name: "Tim", last_name: "Thompson") }
  let!(:pods) { create_list(:pod, 10) }

  before(:each) do
    SearchCache.refresh
  end

  it "creates new person and caller role" do
    login_as nil

    visit "/a/waitlist/callers"
    click_on "New Caller"
    expect(page).to have_current_path("/a/people/new?role=caller")

    fill_in "First name", with: "Bob"
    fill_in "Last name", with: "Jones"
    fill_in "Phone", with: "12345"

    expect { click_on "Save" }.to change { Person.count }.by(1).and change { Caller.count }.by(1)
    person = Person.last
    caller = Caller.last

    expect(page).to have_current_path("/a/people/#{person.id}/edit/personal_details")

    person.reload
    expect(person.first_name).to eq("Bob")
    expect(person.last_name).to eq("Jones")
    expect(person.phone).to eq("12345")
    expect(person.caller).to eq(caller)
    expect(person.caller.status).to eq(:waiting_list)
    expect(person.caller.status_change_datetime.strftime("%Y-%m-%d")).to eq(Date.today.strftime("%Y-%m-%d"))
  end

  it "creates new caller for existing person" do
    login_as nil

    visit "/a/people/new?role=caller"

    fill_in "Search", with: "Tim"
    find("a", text: "add caller role").click
    expect(page).to have_current_path("/a/people/#{person.id}/actions")

    expect { click_on "Add caller role" }.to change { Caller.count }.by(1)

    expect(page).to have_current_path("/a/people/#{person.id}/events")

    person.reload
    expect(person.caller.status).to eq(:active)
    expect(person.caller.status_change_datetime.strftime("%Y-%m-%d")).to eq(Date.today.strftime("%Y-%m-%d"))
  end

  it "links to person profile" do
    login_as nil

    visit "/a/people/new?role=caller"

    fill_in "Search", with: "Tim"
    find("a", text: "go to profile").click
    expect(page).to have_current_path("/a/people/#{person.id}/events")
  end

  it "redirect back to home page on cancel" do
    login_as nil

    visit "/a/waitlist/callers"
    click_on "New Caller"
    click_on "Cancel"
    expect(page).to have_current_path("/a")
  end
end
