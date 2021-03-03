require "rails_helper"

RSpec.describe "emergency contacts", type: :system do
  let!(:emergency_contact) { create(:emergency_contact, callee: callee) }
  let!(:callee) { create(:callee) }

  it "works" do
    login_as nil

    expect(callee.emergency_contacts.count).to eq(1)

    visit "/a/people/#{callee.person.id}"
    click_on "Details"
    click_on "Emergency contacts"
    expect(page).to have_current_path("/a/people/#{callee.person.id}/edit/emergency_contacts")
    expect(
      within(".edit-emergency-contact-#{emergency_contact.id}") { find_field("Name").value },
    ).to eq emergency_contact.name
    expect(
      within(".edit-emergency-contact-#{emergency_contact.id}") { find_field("Relationship").value },
    ).to eq emergency_contact.relationship
    expect(
      within(".edit-emergency-contact-#{emergency_contact.id}") { find_field("Contact details").value },
    ).to eq emergency_contact.contact_details

    # create new
    click_on "New emergency contact"
    within(".new-emergency-contact") { fill_in("Name", with: "name1") }
    within(".new-emergency-contact") { fill_in("Relationship", with: "relationship1") }
    within(".new-emergency-contact") { fill_in("Contact details", with: "contact1") }
    within(".new-emergency-contact") { click_on("Save") }

    callee.reload
    expect(callee.emergency_contacts.count).to eq(2)
    new_emergency_contact = EmergencyContact.last
    expect(new_emergency_contact.name).to eq("name1")
    expect(new_emergency_contact.relationship).to eq("relationship1")
    expect(new_emergency_contact.contact_details).to eq("contact1")

    expect(
      within(".edit-emergency-contact-#{new_emergency_contact.id}") { find_field("Name").value },
    ).to eq new_emergency_contact.name
    expect(
      within(".edit-emergency-contact-#{new_emergency_contact.id}") { find_field("Relationship").value },
    ).to eq new_emergency_contact.relationship
    expect(
      within(".edit-emergency-contact-#{new_emergency_contact.id}") { find_field("Contact details").value },
    ).to eq new_emergency_contact.contact_details

    # edit existing
    within(".edit-emergency-contact-#{emergency_contact.id}") { fill_in("Name", with: "name") }
    within(".edit-emergency-contact-#{emergency_contact.id}") { fill_in("Relationship", with: "relationship") }
    within(".edit-emergency-contact-#{emergency_contact.id}") { fill_in("Contact details", with: "contact") }
    within(".edit-emergency-contact-#{emergency_contact.id}") { click_on("Update") }

    emergency_contact.reload
    expect(emergency_contact.name).to eq("name")
    expect(emergency_contact.relationship).to eq("relationship")
    expect(emergency_contact.contact_details).to eq("contact")
  end
end
