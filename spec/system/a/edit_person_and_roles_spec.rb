require "rails_helper"

RSpec.describe "edit person and role", type: :system do
  let!(:person) { create(:person) }
  let!(:admin) { create(:admin, person: person) }
  let!(:caller) { create(:caller, person: person) }
  let!(:pod_leader) { create(:pod_leader, person: person) }

  let!(:pods) { create_list(:pod, 10, pod_leader: nil) }

  before do
    SearchCache.refresh
  end

  it "works" do
    login_as nil

    visit "/a/people/#{person.id}"
    click_on "Edit"
    expect(page).to have_current_path("/a/people/#{person.id}/edit/personal_details")

    expect(find_field("Title").value).to eq person.title
    expect(find_field("First name").value).to eq person.first_name
    expect(find_field("Last name").value).to eq person.last_name
    # expect(find_field("Email").value).to eq person.email
    # expect(find_field("Phone").value).to eq person.phone

    # expect(find_field("person_admin_attributes_active").checked?).to eq admin.active
    # expect(find_field("person_pod_leader_attributes_active").checked?).to eq pod_leader.active
    # expect(find_field("person_caller_attributes_pod_id").value).to eq caller.pod.id.to_s
    # expect(find_field("person_caller_attributes_experience").value).to eq caller.experience
    # expect(find_field("person_caller_attributes_active").checked?).to eq caller.active

    select "Mx", from: "Title"
    fill_in "First name", with: "Bob"
    fill_in "Last name", with: "Jones"
    # fill_in "Email", with: "bob.jones@gmail.com"
    # fill_in "Phone", with: "12345"

    # check "person_admin_attributes_active"
    # uncheck "person_pod_leader_attributes_active"
    # select pods[1].name, from: "person_caller_attributes_pod_id"
    # fill_in "Experience", with: "experience"
    # check "person_caller_attributes_active"

    expect { click_on "Save" }.to change { Person.count }.by(0)

    expect(page).to have_current_path("/a/people/#{person.id}/events")

    person.reload
    admin.reload
    pod_leader.reload
    caller.reload

    expect(person.title).to eq("MX")
    expect(person.first_name).to eq("Bob")
    expect(person.last_name).to eq("Jones")
    # expect(person.email).to eq("bob.jones@gmail.com")
    # expect(person.phone).to eq("12345")

    # expect(person.admin).to eq(admin)
    # expect(person.pod_leader).to eq(pod_leader)
    # expect(person.caller).to eq(caller)

    # expect(admin.active).to eq(true)

    # expect(pod_leader.active).to eq(nil)

    # expect(caller.pod).to eq(pods[1])
    # expect(caller.experience).to eq("experience")
    # expect(caller.active).to eq(true)
  end
end
