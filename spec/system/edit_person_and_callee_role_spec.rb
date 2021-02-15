require "rails_helper"

RSpec.describe "edit person and callee role", type: :system do
  let!(:person) { create(:person) }
  let!(:callee) { create(:callee, person: person) }
  let!(:pods) { create_list(:pod, 10) }

  it "works" do
    login_as nil

    visit "/a/people/#{person.id}"
    click_on "Edit"
    expect(page).to have_current_path("/a/people/#{person.id}/edit")

    expect(find_field("Title").value).to eq person.title
    expect(find_field("First name").value).to eq person.first_name
    expect(find_field("Last name").value).to eq person.last_name
    expect(find_field("Email").value).to eq person.email
    expect(find_field("Phone").value).to eq person.phone

    expect(find_field("person_callee_attributes_active").checked?).to eq callee.active
    expect(find_field("person_callee_attributes_pod_id").value).to eq callee.pod.id.to_s
    expect(find_field("person_callee_attributes_reason_for_referral").value).to eq callee.reason_for_referral
    expect(find_field("person_callee_attributes_living_arrangements").value).to eq callee.living_arrangements
    expect(find_field("person_callee_attributes_other_information").value).to eq callee.other_information
    expect(find_field("person_callee_attributes_additional_needs").value).to eq callee.additional_needs

    select "Mx", from: "Title"
    fill_in "First name", with: "Bob"
    fill_in "Last name", with: "Jones"
    fill_in "Email", with: "bob.jones@gmail.com"
    fill_in "Phone", with: "12345"

    uncheck "person_callee_attributes_active"
    fill_in "Reason for referral", with: "referral"
    fill_in "Living arrangements", with: "living"
    fill_in "Other information", with: "other"
    fill_in "Additional needs", with: "needs"
    select pods[1].name, from: "Pod"

    expect { click_on "Save" }.to change { Person.count }.by(0)

    expect(page).to have_current_path("/a/people/#{person.id}/details")

    person.reload
    callee.reload

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
    expect(callee.active).to eq(nil)
  end
end
