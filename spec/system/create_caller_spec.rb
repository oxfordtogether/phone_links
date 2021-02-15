require "rails_helper"

RSpec.describe "create caller", type: :system do
  let!(:person) { create(:person, first_name: "Tim", last_name: "Thompson") }
  let!(:pods) { create_list(:pod, 10) }

  before do
    SearchCache.refresh
  end

  it "creates new person and caller role" do
    login_as nil

    visit "/a/waitlist/callers"
    click_on "New Caller"
    expect(page).to have_current_path("/a/people/new?role=caller&redirect_on_cancel=/a/waitlist/callers")

    select "Mx", from: "Title"
    fill_in "First name", with: "Bob"
    fill_in "Last name", with: "Jones"
    fill_in "Email", with: "bob.jones@gmail.com"
    fill_in "Phone", with: "12345"

    expect { click_on "Next" }.to change { Person.count }.by(1)
    person = Person.last

    expect(page).to have_current_path("/a/people/#{person.id}/caller/new")

    select pods[1].name, from: "Pod"
    fill_in "Experience", with: "experience"
    check "Active"

    expect { click_on "Save" }.to change { Caller.count }.by(1)
    caller = Caller.last

    expect(page).to have_current_path("/a/people/#{person.id}/details")

    person.reload
    expect(person.title).to eq("MX")
    expect(person.first_name).to eq("Bob")
    expect(person.last_name).to eq("Jones")
    expect(person.email).to eq("bob.jones@gmail.com")
    expect(person.phone).to eq("12345")
    expect(person.caller).to eq(caller)
    expect(caller.pod).to eq(pods[1])
    expect(caller.experience).to eq("experience")
    expect(caller.active).to eq(true)
  end

  it "creates new caller for existing person" do
    login_as nil

    visit "/a/people/new?role=caller"

    fill_in "Search", with: "Tim"
    find("a", text: "add caller role").click
    expect(page).to have_current_path("/a/people/#{person.id}/caller/new")

    expect { click_on "Save" }.to change { Caller.count }.by(1)

    expect(page).to have_current_path("/a/people/#{person.id}/details")
  end

  it "links to person profile" do
    login_as nil

    visit "/a/people/new?role=caller"

    fill_in "Search", with: "Tim"
    find("a", text: "go to profile").click
    expect(page).to have_current_path("/a/people/#{person.id}/events")
  end

  it "redirect back to correct page on cancel" do
    login_as nil

    visit "/a/waitlist/callers"
    click_on "New Caller"
    click_on "Cancel"
    expect(page).to have_current_path("/a/waitlist/callers")

    visit "/a/waitlist/callers"
    click_on "New Caller"
    fill_in "Search", with: "Tim"
    find("a", text: "add caller role").click
    expect(page).to have_current_path("/a/people/#{person.id}/caller/new")
    find("h1", text: "New Caller") # make sure page actually loaded
    click_on "Cancel"
    expect(page).to have_current_path("/a/people/#{person.id}/events")
  end
end
