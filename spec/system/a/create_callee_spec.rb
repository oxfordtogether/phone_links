require "rails_helper"

RSpec.describe "create callee", type: :system do
  let!(:person) { create(:person, first_name: "Tim", last_name: "Thompson") }
  let!(:admin) do
    create(:admin, person: create(:person, first_name: "Tim", last_name: "Jones"))
  end
  let!(:pods) { create_list(:pod, 10) }

  before do
    SearchCache.refresh
  end

  it "creates new person and callee role" do
    login_as nil

    visit "/a/waitlist/callees"
    click_on "New Callee"
    expect(page).to have_current_path("/a/people/new?role=callee&redirect_on_cancel=/a/waitlist/callees")

    select "Mx", from: "Title"
    fill_in "First name", with: "Bob"
    fill_in "Last name", with: "Jones"
    fill_in "Email", with: "bob.jones@gmail.com"
    fill_in "Phone", with: "12345"

    expect { click_on "Next" }.to change { Person.count }.by(1)
    person = Person.last

    expect(page).to have_current_path("/a/people/#{person.id}/callee/new")

    select pods[1].name, from: "Pod"
    fill_in "Reason for referral", with: "referral"
    fill_in "Living arrangements", with: "living"
    fill_in "Other information", with: "other"
    fill_in "Additional needs", with: "needs"
    check "Active"

    expect { click_on "Save" }.to change { Callee.count }.by(1)
    callee = Callee.last

    expect(page).to have_current_path("/a/people/#{person.id}/events")

    person.reload
    expect(person.title).to eq("MX")
    expect(person.first_name).to eq("Bob")
    expect(person.last_name).to eq("Jones")
    expect(person.email).to eq("bob.jones@gmail.com")
    expect(person.phone).to eq("12345")
    expect(person.callee).to eq(callee)

    expect(callee.pod).to eq(pods[1])
    expect(callee.reason_for_referral).to eq("referral")
    expect(callee.living_arrangements).to eq("living")
    expect(callee.other_information).to eq("other")
    expect(callee.additional_needs).to eq("needs")
    expect(callee.active).to eq(true)
  end

  it "creates new callee for existing person" do
    login_as nil

    visit "/a/waitlist/callees"
    click_on "New Callee"
    expect(page).to have_current_path("/a/people/new?role=callee&redirect_on_cancel=/a/waitlist/callees")

    visit "/a/people/new?role=callee"

    fill_in "Search", with: "Tim"

    admin_result = find_by_id("result_person_#{admin.person.id}")
    expect(admin_result).to have_no_link("add callee role")

    person_result = find_by_id("result_person_#{person.id}")
    expect(person_result).to have_link("add callee role")

    find("a", text: "add callee role").click
    expect(page).to have_current_path("/a/people/#{person.id}/callee/new")

    expect { click_on "Save" }.to change { Callee.count }.by(1)

    expect(page).to have_current_path("/a/people/#{person.id}/events")
  end

  it "links to person profile" do
    login_as nil

    visit "/a/people/new?role=callee"

    fill_in "Search", with: "Tim"
    first("a", text: "go to profile").click
    expect(page).to have_current_path("/a/people/#{person.id}/events")
  end

  it "redirect back to correct page on cancel" do
    login_as nil

    visit "/a/waitlist/callees"
    click_on "New Callee"
    click_on "Cancel"
    expect(page).to have_current_path("/a/waitlist/callees")

    visit "/a/waitlist/callees"
    click_on "New Callee"
    fill_in "Search", with: "Tim"
    find("a", text: "add callee role").click
    expect(page).to have_current_path("/a/people/#{person.id}/callee/new")
    find("h1", text: "New Callee") # make sure page actually loaded
    click_on "Cancel"
    expect(page).to have_current_path("/a/people/#{person.id}/events")
  end
end
