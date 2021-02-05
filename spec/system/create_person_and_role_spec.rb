require "rails_helper"

RSpec.describe "create person and role flow", type: :system do
  let!(:person) { create(:person, first_name: "Tim", last_name: "Thompson") }
  let!(:admin) { create(:admin, person: person) }

  before do
    SearchCache.refresh
  end

  it "creates new person and caller" do
    login_as nil

    visit "/waitlist/callers"

    click_on "New Caller"

    expect(page).to have_current_path("/people/new?role=caller")

    fill_in "Title", with: "Mx"
    fill_in "First name", with: "Bob"
    fill_in "Last name", with: "Jones"
    fill_in "Email", with: "bob.jones@gmail.com"
    fill_in "Phone", with: "12345"

    expect { click_on "Next" }.to change { Person.count }.from(1).to(2)

    new_person = Person.last

    expect(page).to have_current_path("/people/#{new_person.id}/disambiguate?role=caller")

    click_on "Continue"

    expect(page).to have_current_path("/people/#{new_person.id}/caller/new")

    fill_in "caller_start_date(3i)", with: "01"
    fill_in "caller_start_date(2i)", with: "11"
    fill_in "caller_start_date(1i)", with: "2020"

    expect { click_on "Save" }.to change { Caller.count }.from(0).to(1)

    expect(page).to have_current_path("/people/#{new_person.id}/events")

    new_person.reload
    expect(new_person.caller).to_not be_nil
  end

  it "creates new caller for existing person" do
    login_as nil

    visit "/waitlist/callers"

    click_on "New Caller"

    expect(page).to have_current_path("/people/new?role=caller")

    fill_in "Search", with: "Tim"

    find("p", text: "Tim Thompson").click

    expect(page).to have_current_path("/people/#{person.id}/caller/new")

    fill_in "caller_start_date(3i)", with: "01"
    fill_in "caller_start_date(2i)", with: "11"
    fill_in "caller_start_date(1i)", with: "2020"

    expect { click_on "Save" }.to change { Caller.count }.from(0).to(1)

    expect(page).to have_current_path("/people/#{person.id}/events")
  end
end
