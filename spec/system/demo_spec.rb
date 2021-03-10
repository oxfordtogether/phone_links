require "rails_helper"

RSpec.describe "login", type: :system do
  # let(:admin) { create(:admin, active: true) }
  let(:pod_leader) { create(:pod_leader, active: true) }
  let(:caller) { create(:caller, active: true) }

  it "displays demo banner" do
    login_as nil

    ENV["DEMO"] = "true"

    visit "/a"
    expect(page).to have_content("Demo")

    visit "/pl/#{pod_leader.id}"
    expect(page).to have_content("Demo")

    visit "/c/#{caller.id}"
    expect(page).to have_content("Demo")

    ENV["BYPASS_AUTH"] = nil
  end

  # it "does not display demo banner" do
  #   ENV["BYPASS_AUTH"] = "false"

  #   ENV["BYPASS_AUTH"] = "true"
  #   visit "/"
  #   expect(current_path).to eq("/login")
  # end
end
