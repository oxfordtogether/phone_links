require "rails_helper"

RSpec.describe "add roles to caller", type: :system do
  let!(:caller) { create(:caller) }
  let!(:pod_leader) { create(:pod_leader) }

  it "adds admin role" do
    login_as nil

    visit "/people/#{caller.person.id}"
    click_on "More actions"
    click_on "Add Admin role"

    expect(page).to have_current_path("/people/#{caller.person.id}/admin/new")

    expect do
      click_on "Save"
    end.to change { Admin.count }.by(1)

    expect(page).to have_current_path("/people/#{caller.person.id}/details")

    caller.reload
    expect(caller.person.admin).to eq(Admin.last)
  end

  it "displays correct set of options" do
    login_as nil

    visit "/people/#{caller.person.id}/actions"

    expect(find("a", text: "Add Pod Leader role")).to be_present
    expect(find("a", text: "Add Admin role")).to be_present

    visit "/people/#{pod_leader.person.id}/actions"

    expect(find("a", text: "Add Admin role")).to be_present
    expect(find("a", text: "Add Caller role")).to be_present
  end

  it "cancels attempt to add admin role" do
    login_as nil

    visit "/people/#{caller.person.id}/actions"

    click_on "Add Admin role"
    expect(page).to have_current_path("/people/#{caller.person.id}/admin/new")

    click_on "Cancel"

    expect(page).to have_current_path("/people/#{caller.person.id}/details")
    caller.reload
    expect(caller.person.admin).to eq(nil)
  end

  it "cancels attempt to add pod leader role" do
    login_as nil

    visit "/people/#{caller.person.id}/actions"
    click_on "Add Pod Leader role"
    expect(page).to have_current_path("/people/#{caller.person.id}/pod_leader/new")

    click_on "Cancel"

    expect(page).to have_current_path("/people/#{caller.person.id}/details")
    caller.reload
    expect(caller.person.pod_leader).to eq(nil)
  end

  it "cancels attempt to add caller role" do
    login_as nil

    visit "/people/#{pod_leader.person.id}/actions"
    click_on "Add Caller role"
    expect(page).to have_current_path("/people/#{pod_leader.person.id}/caller/new")

    click_on "Cancel"

    expect(page).to have_current_path("/people/#{pod_leader.person.id}/events")
    pod_leader.reload
    expect(pod_leader.person.caller).to eq(nil)
  end
end
