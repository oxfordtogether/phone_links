require "rails_helper"

RSpec.describe "create pod leader", type: :system do
  let!(:person) { create(:person, first_name: "Tim", last_name: "Thompson") }
  let!(:pods) { create_list(:pod, 10) }

  before do
    SearchCache.refresh
  end

  it "creates new person and pod_leader role" do
    login_as nil

    visit "/admin/pod_leaders"
    click_on "New Pod Leader"
    expect(page).to have_current_path("/people/new?role=pod_leader&redirect_on_cancel=/admin/pod_leaders")

    select "Mx", from: "Title"
    fill_in "First name", with: "Bob"
    fill_in "Last name", with: "Jones"
    fill_in "Email", with: "bob.jones@gmail.com"
    fill_in "Phone", with: "12345"

    expect { click_on "Next" }.to change { Person.count }.by(1)
    person = Person.last

    expect(page).to have_current_path("/people/#{person.id}/pod_leader/new")

    check "Active"

    expect { click_on "Save" }.to change { PodLeader.count }.by(1)
    pod_leader = PodLeader.last

    expect(page).to have_current_path("/people/#{person.id}/events")

    person.reload
    expect(person.title).to eq("MX")
    expect(person.first_name).to eq("Bob")
    expect(person.last_name).to eq("Jones")
    expect(person.email).to eq("bob.jones@gmail.com")
    expect(person.phone).to eq("12345")
    expect(person.pod_leader).to eq(pod_leader)
    expect(pod_leader.active).to eq(true)
  end

  it "creates new pod_leader for existing person" do
    login_as nil

    visit "/people/new?role=pod_leader"

    fill_in "Search", with: "Tim"
    find("a", text: "add pod_leader role").click
    expect(page).to have_current_path("/people/#{person.id}/pod_leader/new")

    expect { click_on "Save" }.to change { PodLeader.count }.by(1)

    expect(page).to have_current_path("/people/#{person.id}/events")
  end

  it "links to person profile" do
    login_as nil

    visit "/people/new?role=pod_leader"

    fill_in "Search", with: "Tim"
    find("a", text: "go to profile").click
    expect(page).to have_current_path("/people/#{person.id}/events")
  end

  it "redirect back to correct page on cancel" do
    login_as nil

    visit "/admin/pod_leaders"
    click_on "New Pod Leader"
    click_on "Cancel"
    expect(page).to have_current_path("/admin/pod_leaders")

    visit "/admin/pod_leaders"
    click_on "New Pod Leader"
    fill_in "Search", with: "Tim"
    find("a", text: "add pod_leader role").click
    expect(page).to have_current_path("/people/#{person.id}/pod_leader/new")
    find("h1", text: "New Pod Leader") # make sure page actually loaded
    click_on "Cancel"
    expect(page).to have_current_path("/people/#{person.id}/events")
  end
end
