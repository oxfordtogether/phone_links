require "rails_helper"

RSpec.describe "root", type: :system do
  it "redirects to /login if user isn't logged in" do
    visit "/"

    expect(find("h1", text: "Hi")).to be_present

    expect(current_path).to eq("/")
  end
end
