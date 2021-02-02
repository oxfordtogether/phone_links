require "rails_helper"

RSpec.describe "login", type: :system do
  it "redirects to /login if user isn't logged in" do
    visit "/"
    expect(current_path).to eq("/login")
  end

  it "displays homepage given valid permissions" do
    login_as nil

    visit "/"
    expect(current_path).to eq("/")
  end

  it "prevents access given invalid permissions" do
    login_as(nil, permissions: ["not-valid"])

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
