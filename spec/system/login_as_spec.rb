require "rails_helper"

RSpec.describe "login as", type: :system do
  let!(:admin) { create(:admin, status: "active") }
  let!(:pod_leaders) { create_list(:pod_leader, 10, status: "active") }
  let!(:callers) { create_list(:caller, 10, status: "active") }

  before do
    ENV["BYPASS_AUTH"] = "false"
  end

  after do
    ENV["BYPASS_AUTH"] = "true"
  end

  it "allows admin to login as pod leader" do
    login_as admin.person

    expect(current_path).to eq("/a")
    expect(page).to have_content("Hi #{admin.name}")

    click_on "Admin"
    click_on "Pod Leaders"

    click_link href: "/pl/#{pod_leaders[0].id}"

    expect(current_path).to eq("/pl/#{pod_leaders[0].id}")
    expect(page).to have_content("Hi #{pod_leaders[0].name}")

    click_on "Back to Admin"

    expect(current_path).to eq("/a")
    expect(page).to have_content("Hi #{admin.name}")
  end

  it "allows admin to login as caller" do
    login_as admin.person

    expect(current_path).to eq("/a")
    expect(page).to have_content("Hi #{admin.name}")

    click_on "Admin"
    click_on "Callers"

    click_link href: "/c/#{callers[0].id}"

    expect(current_path).to eq("/c/#{callers[0].id}")
    expect(page).to have_content("Hi #{callers[0].name}")

    click_on "Back to Admin"

    expect(current_path).to eq("/a")
    expect(page).to have_content("Hi #{admin.name}")
  end

  it "hides back to links for pod leaders and callers" do
    login_as pod_leaders[0].person

    expect(current_path).to eq("/pl/#{pod_leaders[0].id}")
    expect(page).to have_content("Hi #{pod_leaders[0].name}")

    expect(page).to_not have_content("Back to Admin")

    login_as callers[0].person

    expect(current_path).to eq("/c/#{callers[0].id}")
    expect(page).to have_content("Hi #{callers[0].name}")

    expect(page).to_not have_content("Back to Admin")

  end
end
