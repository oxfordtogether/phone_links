require "rails_helper"

RSpec.describe "add roles to caller", type: :system do
  let!(:caller) { create(:caller) }
  let!(:pod_leader) { create(:pod_leader) }
  let!(:admin) { create(:admin) }

  it "displays correct set of options" do
    login_as nil

    visit "/a/people/#{caller.person.id}/actions"

    expect(find(".new-pod-leader-role")).to be_present
    expect(find(".new-admin-role")).to be_present

    visit "/a/people/#{pod_leader.person.id}/actions"

    expect(find(".new-caller-role")).to be_present
    expect(find(".new-admin-role")).to be_present

    visit "/a/people/#{admin.person.id}/actions"

    expect(find(".new-pod-leader-role")).to be_present
    expect(find(".new-caller-role")).to be_present
  end
end
