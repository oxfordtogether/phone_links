require "rails_helper"

RSpec.describe "edit referral", type: :system do
  let!(:person) { create(:person) }
  let!(:referral) { create(:referral, status: "unread") }

  it "changes status" do
    login_as nil

    visit "/a"
    click_on "Referrals"
    find("tr", text: referral.full_name).click

    expect(page).to have_current_path("/a/referrals/#{referral.id}")

    expect(find_field("Status").value).to eq "unread"
    expect(find_field("Notes").value).to eq ""

    select "in progress", from: "Status"
    fill_in "Notes", with: "test"

    expect do
      click_on "Save"
    end.to change { Referral.count }.by(0).and change { ReferralStatusChange.count }.by(1)

    safeguarding_concern.reload

    expect(page).to have_current_path("/a/referrals/#{referral.id}")

    expect(referral.status).to eq(:in_progress)
    expect(referral.status_changed_notes).to eq("test")
  end

  it "creates callee" do
    visit "/a/referrals/#{referral.id}"

    expect do
      click_on "Create callee from referral"
    end.to change { Callee.count }.by(1).and change { EmergencyContact.count }.by(1)

    callee = Callee.last
    person = callee.person
    emergency_contact = EmergencyContact.last

    referral.reload
    expect(referral.callee).to eq(callee)

    expect(person.first_name).to eq(referral.first_name)
    expect(person.last_name).to eq(referral.last_name)
    expect(person.phone).to eq(referral.phone)
    expect(person.age_bracket).to eq(referral.age_bracket)

    expect(person.address_line_1).to eq(referral.address_line_1)
    expect(person.address_line_2).to eq(referral.address_line_2)
    expect(person.address_town).to eq(referral.address_town)
    expect(person.address_postcode).to eq(referral.address_postcode)

    expect(callee.reason_for_referral).to eq(referral.reason_for_referral)
    expect(callee.additional_needs).to eq(referral.additional_needs)
    expect(callee.other_information).to eq(referral.other_information)
    expect(callee.languages_notes).to eq(referral.languages)

    expect(emergency_contact.name).to eq(referral.emergency_contact_name)
    expect(emergency_contact.relationship).to eq(referral.emergency_contact_relationship)
    expect(emergency_contact.contact_details).to eq(referral.emergency_contact_details)
    expect(emergency_contact.callee).to eq(callee)

    expect(page).to have_current_path("/a/people/#{callee.person.id}/events")
  end
end
