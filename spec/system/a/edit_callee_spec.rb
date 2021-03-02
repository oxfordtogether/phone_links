require "rails_helper"

RSpec.describe "edit callee", type: :system do
  let!(:person) { create(:person) }
  let!(:callee) { create(:callee, person: person) }
  let!(:pods) { create_list(:pod, 10) }

  it "shows correct tabs" do
    login_as nil

    visit "/a/people/#{person.id}"
    click_on "Details"
    expect(page).to have_current_path("/a/people/#{person.id}/edit/personal_details")

    expect(page).to have_content("Personal")
    expect(page).to have_content("Contact")
    expect(page).to have_content("Referral details")
  end

  it "edits personal info" do
    login_as nil

    visit "/a/people/#{person.id}"
    click_on "Edit"
    expect(page).to have_current_path("/a/people/#{person.id}/edit/personal_details")

    expect(find_field("Title").value).to eq person.title
    expect(find_field("First name").value).to eq person.first_name
    expect(find_field("Last name").value).to eq person.last_name

    select "Mx", from: "Title"
    fill_in "First name", with: "Bob"
    fill_in "Last name", with: "Jones"

    expect { click_on "Save" }.to change { Person.count }.by(0)

    expect(page).to have_current_path("/a/people/#{person.id}/events")

    person.reload
    expect(person.title).to eq("MX")
    expect(person.first_name).to eq("Bob")
    expect(person.last_name).to eq("Jones")
  end

  it "edits contact info" do
    login_as nil

    visit "/a/people/#{person.id}"
    click_on "Edit"
    click_on "Contact"
    expect(page).to have_current_path("/a/people/#{person.id}/edit/contact_details")

    expect(find_field("Email").value).to eq person.email
    expect(find_field("Phone").value).to eq person.phone
    expect(find_field("Address line 1").value).to eq person.address_line_1
    expect(find_field("Address line 2").value).to eq person.address_line_2
    expect(find_field("Town").value).to eq person.address_town
    expect(find_field("Postcode").value).to eq person.address_postcode

    fill_in "Email", with: "bob.jones@gmail.com"
    fill_in "Phone", with: "12345"
    fill_in "Address line 1", with: "1 RR"
    fill_in "Address line 2", with: "XX"
    fill_in "Town", with: "Town"
    fill_in "Postcode", with: "XXX"

    click_on "Save"

    person.reload
    expect(person.email).to eq("bob.jones@gmail.com")
    expect(person.phone).to eq("12345")
    expect(person.address_line_1).to eq("1 RR")
    expect(person.address_line_2).to eq("XX")
    expect(person.address_town).to eq("Town")
    expect(person.address_postcode).to eq("XXX")
  end

  it "edits referral details" do
    login_as nil

    visit "/a/people/#{person.id}"
    click_on "Edit"
    click_on "Referral details"
    expect(page).to have_current_path("/a/people/#{person.id}/edit/referral_details")

    expect(find_field("person_callee_attributes_reason_for_referral").value).to eq callee.reason_for_referral
    expect(find_field("person_callee_attributes_living_arrangements").value).to eq callee.living_arrangements
    expect(find_field("person_callee_attributes_other_information").value).to eq callee.other_information
    expect(find_field("person_callee_attributes_additional_needs").value).to eq callee.additional_needs
    expect(find_field("person_callee_attributes_call_frequency").value).to eq callee.call_frequency

    fill_in "Reason for referral", with: "referral"
    fill_in "Living arrangements", with: "living"
    fill_in "Other information", with: "other"
    fill_in "Additional needs", with: "needs"
    fill_in "Call frequency", with: "call_frequency"

    click_on "Save"

    callee.reload
    expect(callee.reason_for_referral).to eq("referral")
    expect(callee.living_arrangements).to eq("living")
    expect(callee.other_information).to eq("other")
    expect(callee.additional_needs).to eq("needs")
    expect(callee.call_frequency).to eq("call_frequency")
  end
end

# TO DO
# expect(find_field("person_callee_attributes_active").checked?).to eq callee.active
# expect(find_field("person_callee_attributes_pod_id").value).to eq callee.pod.id.to_s
# uncheck "person_callee_attributes_active"
# select pods[1].name, from: "Pod"
# expect(callee.pod).to eq(pods[1])
# expect(callee.active).to eq(nil)
