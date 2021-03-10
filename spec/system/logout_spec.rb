require "rails_helper"

RSpec.describe "logout", type: :system do
  let!(:admin) { create(:admin, status: "active") }

  before do
    ENV["BYPASS_AUTH"] = "false"
  end

  after do
    ENV["BYPASS_AUTH"] = "true"
  end

  it "works" do
    login_as admin.person

    visit "/"

    click_on "Logout"

    expect(current_path).to eq("/logout")
  end
end
