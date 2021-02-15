require "rails_helper"

RSpec.describe "login", type: :system do
  let(:admin) { create(:admin, active: true) }
  let(:admin_no_active) { create(:admin, active: false) }
  let(:caller) { create(:caller) }

  before do
    ENV["BYPASS_AUTH"] = "false"
  end

  after do
    ENV["BYPASS_AUTH"] = "true"
  end

  it "redirects to /login if user isn't logged in" do
    visit "/"
    expect(current_path).to eq("/login")
  end

  it "logs in and shows homepage for active admin" do
    login_as admin.person

    visit "/"
    expect(current_path).to eq("/a")
  end

  it "prevents access for non-active admin" do
    login_as admin_no_active.person

    visit "/"
    expect(current_path).to eq("/invalid_permissions")
  end

  it "prevents access for non-program participants" do
    login_as nil

    visit "/"
    expect(current_path).to eq("/invalid_permissions")
  end

  it "prevents access for non-admins" do
    login_as caller.person

    visit "/"
    expect(current_path).to eq("/invalid_permissions")
  end

  it "/invalid_permissions links to logout" do
    login_as admin_no_active.person

    visit "/"
    expect(current_path).to eq("/invalid_permissions")

    click_on "Back"
    expect(current_path).to eq("/logout")
  end

  # it "prevents access given invalid tenant" do
  #   login_as(nil, tenants: ["not-valid"])

  #   visit "/"
  #   expect(current_path).to eq("/invalid_permissions")

  #   click_on "Back"
  #   expect(current_path).to eq("/logout")
  # end
end
