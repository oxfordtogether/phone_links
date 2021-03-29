require "rails_helper"

RSpec.describe "create admin", type: :system do
  let!(:person) { create(:person, first_name: "Tim", last_name: "Thompson") }
  let!(:pods) { create_list(:pod, 10) }

  before(:each) do
    SearchCache.refresh
  end

  it "creates new person and admin role" do
    login_as nil

    visit "/a/admin/admins"
    click_on "New Admin"
    expect(page).to have_current_path("/a/people/new?role=admin&redirect_on_cancel=/a/admin/admins")

    fill_in "First name", with: "Bob"
    fill_in "Last name", with: "Jones"
    fill_in "Phone", with: "12345"

    expect { click_on "Save" }.to change { Person.count }.by(1).and change { Admin.count }.by(1)

    person = Person.last
    expect(page).to have_current_path("/a/people/#{person.id}/edit/personal_details")

    expect(person.first_name).to eq("Bob")
    expect(person.last_name).to eq("Jones")
    expect(person.phone).to eq("12345")
    expect(person.admin.status).to eq(:active)
    expect(person.admin.status_change_datetime.strftime("%Y-%m-%d")).to eq(Date.today.strftime("%Y-%m-%d"))
  end

  it "creates new admin for existing person" do
    login_as nil

    visit "/a/people/new?role=admin"

    fill_in "Search", with: "Tim"
    find("a", text: "add admin role").click
    expect(page).to have_current_path("/a/people/#{person.id}/actions")

    expect { click_on "Add admin role" }.to change { Admin.count }.by(1)

    expect(page).to have_current_path("/a/people/#{person.id}/events")

    person.reload
    expect(person.admin.status).to eq(:active)
    expect(person.admin.status_change_datetime.strftime("%Y-%m-%d")).to eq(Date.today.strftime("%Y-%m-%d"))
  end

  it "links to person profile" do
    login_as nil

    visit "/a/people/new?role=admin"

    fill_in "Search", with: "Tim"
    find("a", text: "go to profile").click
    expect(page).to have_current_path("/a/people/#{person.id}/events")
  end

  it "redirect back to correct page on cancel" do
    login_as nil

    visit "/a/admin/admins"
    click_on "New Admin"
    click_on "Cancel"
    expect(page).to have_current_path("/a/admin/admins")
  end
end
