require "rails_helper"

RSpec.describe "logout", type: :system do
  let!(:admin) { create(:admin, person: create(:person, email: "admin@test.com", auth0_id: "234"), status: "active") }

  before do
    ENV["BYPASS_AUTH"] = "false"
  end

  after do
    ENV["BYPASS_AUTH"] = "true"
    Current.person_id = nil
  end

  it "works" do
    login_as admin.person

    visit "/"

    click_on "Logout"

    expect(current_path).to eq("/logout")
  end
end
