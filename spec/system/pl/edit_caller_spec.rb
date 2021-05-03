require "rails_helper"

RSpec.describe "edit caller", type: :system do
  let!(:pod) { create(:pod) }
  let!(:pod_leader) { create(:pod_leader, pods: [pod]) }
  let!(:caller) { create(:caller, pod: pod) }

  it "edits status" do
    login_as nil

    visit "/pl/people/#{caller.person.id}"
    click_on "Status"
    expect(page).to have_current_path("/pl/callers/#{caller.id}/status")

    expect(find_field("caller_status").value).to eq caller.status.to_s
    expect(find_field("caller_status_change_notes").value).to eq ""

    select "Left programme", from: "Status"
    fill_in "Status change notes", with: "boo"

    expect do
      click_on "Save"
    end.to change { RoleStatusChange.count }.by(1)

    caller.reload
    status_change = RoleStatusChange.last

    expect(caller.status).to eq(:left_programme)
    expect(caller.status_change_notes).to eq("boo")
    expect(caller.status_change_datetime.strftime("%Y-%m-%d")).to eq(Date.today.strftime("%Y-%m-%d"))

    expect(status_change.caller).to eq(caller)
    expect(status_change.status).to eq(:left_programme)
    expect(status_change.notes).to eq("boo")
  end

  it "edits check in frequency" do
    login_as nil

    visit "/pl/people/#{caller.person.id}"
    click_on "Details"
    click_on "Check-ins"
    expect(page).to have_current_path("/pl/people/#{caller.person.id}/edit/check_ins")

    expect(find_field("Check-in frequency").value).to eq caller.check_in_frequency.to_s || ""

    select "Every 2 months", from: "Check-in frequency"

    expect do
      click_on "Save"
    end.to change { RoleStatusChange.count }.by(0)

    caller.reload

    expect(caller.check_in_frequency).to eq(:every_2_months)
  end

  it "edits address" do
    login_as nil

    visit "/pl/people/#{caller.person.id}"
    click_on "Details"
    expect(page).to have_current_path("/pl/people/#{caller.person.id}/edit/contact_details")

    expect(find_field("Phone").value).to eq caller.person.phone
    expect(find_field("Address line 1").value).to eq caller.person.address_line_1
    expect(find_field("Address line 2").value).to eq caller.person.address_line_2
    expect(find_field("Town").value).to eq caller.person.address_town
    expect(find_field("Postcode").value).to eq caller.person.address_postcode

    fill_in "Phone", with: "12345"
    fill_in "Address line 1", with: "1 RR"
    fill_in "Address line 2", with: "XX"
    fill_in "Town", with: "Town"
    fill_in "Postcode", with: "XXX"

    click_on "Save"

    caller.person.reload
    expect(caller.person.phone).to eq("12345")
    expect(caller.person.address_line_1).to eq("1 RR")
    expect(caller.person.address_line_2).to eq("XX")
    expect(caller.person.address_town).to eq("Town")
    expect(caller.person.address_postcode).to eq("XXX")
  end

  it "edits social" do
    login_as nil

    visit "/pl/people/#{caller.person.id}"
    click_on "Details"
    click_on "Social"
    expect(page).to have_current_path("/pl/people/#{caller.person.id}/edit/social")

    expect(find_field("Is caller a member of the pod WhatsApp group?").checked?).to eq caller.pod_whatsapp_membership.present?
    check "Is caller a member of the pod WhatsApp group?"
    click_on "Save"

    caller.reload
    expect(caller.pod_whatsapp_membership).to eq(true)
    expect(find_field("Is caller a member of the pod WhatsApp group?").checked?).to eq true

    uncheck "Is caller a member of the pod WhatsApp group?"
    click_on "Save"

    capacity_last_updated = caller.capacity_last_updated

    caller.reload
    expect(caller.pod_whatsapp_membership).to eq(nil)
    expect(find_field("Is caller a member of the pod WhatsApp group?").checked?).to eq false

    expect(caller.capacity_last_updated).to eq(capacity_last_updated)
  end

  it "edits capacity" do
    login_as nil

    visit "/pl/people/#{caller.person.id}"
    click_on "Details"
    click_on "Capacity"
    expect(page).to have_current_path("/pl/people/#{caller.person.id}/edit/capacity")

    expect(find_field("Does the caller have the capacity for another match?").checked?).to eq caller.has_capacity.present?
    expect(find_field("Notes on caller's capacity").value).to eq caller.capacity_notes

    check "Does the caller have the capacity for another match?"
    fill_in "Notes on caller's capacity", with: "notes"

    click_on "Save"

    capacity_last_updated = caller.capacity_last_updated

    caller.reload
    expect(caller.has_capacity).to eq(true)
    expect(caller.capacity_notes).to eq("notes")
    expect(caller.capacity_last_updated).to_not eq(capacity_last_updated)
  end
end
