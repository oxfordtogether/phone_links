require "rails_helper"

RSpec.describe "create pod leader", type: :system do
  let!(:person) { create(:person, first_name: "Tim", last_name: "Thompson") }

  before(:each) do
    SearchCache.refresh
  end

  it "creates new person and pod_leader role" do
    login_as nil

    visit "/a/admin/pod_leaders"
    click_on "New Pod Leader"
    expect(page).to have_current_path("/a/people/new?role=pod_leader")

    fill_in "First name", with: "Bob"
    fill_in "Last name", with: "Jones"
    fill_in "Phone", with: "12345"

    expect { click_on "Save" }.to change { Person.count }.by(1).and change { PodLeader.count }.by(1)
    person = Person.last
    pod_leader = PodLeader.last

    expect(page).to have_current_path("/a/people/#{person.id}/edit/personal_details")

    expect(person.first_name).to eq("Bob")
    expect(person.last_name).to eq("Jones")
    expect(person.phone).to eq("12345")
    expect(person.pod_leader).to eq(pod_leader)
    expect(person.pod_leader.status).to eq(:active)
    expect(person.pod_leader.status_change_datetime.strftime("%Y-%m-%d")).to eq(Date.today.strftime("%Y-%m-%d"))
  end

  it "creates new pod_leader for existing person" do
    login_as nil

    visit "/a/people/new?role=pod_leader"

    fill_in "Search", with: "Tim"
    find("a", text: "add pod leader role").click
    expect(page).to have_current_path("/a/people/#{person.id}/actions")

    expect { click_on "Add pod leader role" }.to change { PodLeader.count }.by(1)

    expect(page).to have_current_path("/a/people/#{person.id}/events")

    person.reload
    expect(person.pod_leader.status).to eq(:active)
    expect(person.pod_leader.status_change_datetime.strftime("%Y-%m-%d")).to eq(Date.today.strftime("%Y-%m-%d"))
  end

  it "links to person profile" do
    login_as nil

    visit "/a/people/new?role=pod_leader"

    fill_in "Search", with: "Tim"
    find("a", text: "go to profile").click
    expect(page).to have_current_path("/a/people/#{person.id}/events")
  end

  it "redirect back to home page on cancel" do
    login_as nil

    visit "/a/admin/pod_leaders"
    click_on "New Pod Leader"
    click_on "Cancel"
    expect(page).to have_current_path("/a")
  end
end
