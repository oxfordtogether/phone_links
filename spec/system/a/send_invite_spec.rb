require "rails_helper"
require "sidekiq/testing"

RSpec.describe "send invite", type: :system do
  let!(:person) { create(:person, auth0_id: nil, email: "test@test.com", invite_email_sent_at: nil) }

  let!(:admin) { create(:admin, person: person) }

  it "shows correct action/status" do
    login_as nil

    person.email = nil
    person.save!

    visit "/a/admin/admins"
    expect(page).to have_content("Missing email")

    person.email = "test@test.com"
    person.save!

    visit "/a/admin/admins"
    expect(page).to have_content("Invite")
    expect(page).to_not have_content("Invite pending")

    person.invite_email_sent_at = DateTime.now
    person.save!

    visit "/a/admin/admins"
    expect(page).to have_content("Invite pending")

    person.auth0_id = "123"
    person.save!

    visit "/a/admin/admins"
    expect(page).to_not have_content("Missing email")
    expect(page).to_not have_content("Invite")
    expect(page).to_not have_content("Invite pending")
  end

  it "sends invite email from /admin lists" do
    login_as nil

    visit "/a/admin/admins"

    expect do
      click_on "Invite"
    end.to change(InviteEmailWorker.jobs, :size).by(1)

    expect(page).to have_content("Invite pending")
    expect(page).to have_current_path("/a/admin/admins")
  end

  it "sends invite email from /people show page" do
    login_as nil

    visit "/a/people/#{person.id}"

    expect do
      click_on "Invite"
    end.to change(InviteEmailWorker.jobs, :size).by(1)

    expect(page).to have_content("Invite pending")
    expect(page).to have_current_path("/a/people/#{person.id}/events")
  end
end
