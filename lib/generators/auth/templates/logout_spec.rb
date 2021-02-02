require "rails_helper"

RSpec.describe "logout", type: :system do
  it "works" do
    login_as nil

    visit "/"

    find("#user-menu").click # this will depend on where logout button is
    click_on "Logout"

    expect(current_path).to eq("/logout")
  end
end
