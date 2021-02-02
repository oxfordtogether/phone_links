require "rails_helper"

RSpec.describe "logout", type: :system do
  it "works" do
    login_as nil

    visit "/"

    click_on "Logout"

    expect(current_path).to eq("/logout")
  end
end
