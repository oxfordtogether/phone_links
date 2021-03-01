require "rails_helper"

RSpec.describe "login", type: :system do
  let!(:pod_leader) { create(:pod_leader, active: true) }
  let!(:pod_leader_no_pod) { create(:pod_leader, active: true) }

  let!(:pod) { create(:pod, pod_leader: pod_leader) }

  before do
    ENV["BYPASS_AUTH"] = "false"
  end

  after do
    ENV["BYPASS_AUTH"] = "true"
  end

  it "allow access for pod leader with pod" do
    login_as pod_leader.person

    visit "/"
    expect(current_path).to eq("/pl/#{pod_leader.id}")
    expect(page.has_text?("Hi #{pod_leader.person.name}")).to eq(true)
    expect(page.has_text?("Welcome to Oxford Hub Phone Links")).to eq(true)

    visit "/pl/#{pod_leader.id}/support"
    expect(page.has_text?("Support")).to eq(true)

    %w[matches callers callees reports].each do |route|
      visit "/pl/#{pod_leader.id}/#{route}"
      expect(page.has_text?(route.humanize)).to eq(true)
    end
  end

  it "limits access for pod leader without pod" do
    login_as pod_leader_no_pod.person

    visit "/"
    expect(current_path).to eq("/pl/#{pod_leader_no_pod.id}")
    expect(page.has_text?("Hi #{pod_leader_no_pod.person.name}")).to eq(true)
    expect(page.has_text?("You aren't an active pod leader.")).to eq(true)

    visit "/pl/#{pod_leader_no_pod.id}/support"
    expect(page.has_text?("Support")).to eq(true)

    %w[matches callers callees reports].each do |route|
      visit "/pl/#{pod_leader_no_pod.id}/#{route}"
      expect(page.has_text?("Invalid permissions")).to eq(true)
    end
  end
end
