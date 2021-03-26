require "rails_helper"

RSpec.describe "submit referral form", type: :system do
  it "works" do
    visit "/referrals/new"

    select "A professional referring someone", from: "I am..."
    fill_in "What organisation do you work for? (if applicable)", with: "charity_1"
    fill_in "Your full name", with: "name"
    fill_in "Your phone number", with: "phone"
    fill_in "Your email address", with: "email"

    fill_in "First name", with: "first_name"
    fill_in "Last name", with: "last_name"
    select "18-35", from: "Age range"

    fill_in "referral_date_of_birth(3i)", with: "03"
    fill_in "referral_date_of_birth(2i)", with: "02"
    fill_in "referral_date_of_birth(1i)", with: "1951"

    fill_in "Postcode", with: "XXX"
    fill_in "Address line 1", with: "1 RR"
    fill_in "Address line 2", with: "XX"
    fill_in "Town", with: "town"
    fill_in "Phone", with: "12345"

    fill_in "Reason for referral", with: "referral"
    fill_in "Do you/they have any additional needs which a caller may need to be aware of?", with: "needs"
    fill_in "Do you/they want phone calls in a language other than English? Please give details.", with: "languages"
    fill_in "Any other information that you would like a caller to know e.g any interests that you, things they like doing or they might like to talk about", with: "information"
    fill_in "What other support does this person currently receive?", with: "support"

    fill_in "Please provide the name of an emergency contact", with: "ec_name"
    fill_in "Relationship to the person being referred", with: "ec_relationship"
    fill_in "Contact details for emergency contact", with: "ec_details"

    check "...you have received the consent of the person to make this referral"
    check "...you agree to the data above being shared with Oxford Hub Phone Link volunteers and leaders"
    check "...you have read and understand the following: This data will be stored with Oxford Hub and you agree to being contacted in relation with this request. If your request needs the involvement of volunteers then some of your data may be shared with a community volunteer so that they can fulfil the task. You agree and understand that Oxford Hub will use it's data in accordance with its privacy policy. Our privacy policy can be found on our website https://www.oxfordhub.org/privacy-statement. I understand that I can withdraw my consent at any time."

    expect do
      click_on "Submit"
    end.to change { Referral.count }.by(1)

    expect(page).to have_content("Referral was successfully submitted.")

    referral = Referral.last

    expect(page).to have_current_path("/referrals/new")

    expect(referral.referrer_type).to eq(:professional)
    expect(referral.referrer_organisation).to eq("charity_1")
    expect(referral.referrer_full_name).to eq("name")
    expect(referral.referrer_phone).to eq("phone")
    expect(referral.referrer_email).to eq("email")

    expect(referral.first_name).to eq("first_name")
    expect(referral.last_name).to eq("last_name")
    expect(referral.age_bracket).to eq(:age_18_35)
    expect(referral.date_of_birth.strftime("%Y-%m-%d")).to eq("1951-02-03")

    expect(referral.address_postcode).to eq("XXX")
    expect(referral.address_line_1).to eq("1 RR")
    expect(referral.address_line_2).to eq("XX")
    expect(referral.address_town).to eq("town")
    expect(referral.phone).to eq("12345")

    expect(referral.reason_for_referral).to eq("referral")
    expect(referral.additional_needs).to eq("needs")
    expect(referral.languages).to eq("languages")
    expect(referral.other_information).to eq("information")
    expect(referral.other_support).to eq("support")

    expect(referral.emergency_contact_name).to eq('ec_name')
    expect(referral.emergency_contact_relationship).to eq('ec_relationship')
    expect(referral.emergency_contact_details).to eq('ec_details')

    expect(referral.confirm_consent).to eq(true)
    expect(referral.confirm_data_shared).to eq(true)
    expect(referral.confirm_data_protection).to eq(true)
  end

  it "is disabled" do
    ENV["REFERRALS_PAUSED"] = "true"

    visit "/referrals/new"
    expect(page).to have_content("Referrals paused")

    ENV["REFERRALS_PAUSED"] = "false"
  end

  it "displays text if submission failed" do
    visit "/referrals/new"

    click_on "Submit"

    expect(page).to have_content("Referral form didn't submit")
  end
end


