require "rails_helper"

RSpec.describe "edit match", type: :system do
  let!(:pod) { create(:pod) }
  let!(:pod_leader) { create(:pod_leader, pods: [pod]) }
  let!(:caller) { create(:caller, status: "active") }
  let!(:match) { create(:match, status: "active", caller: caller, report_frequency: nil) }

  it "handles no reports" do
    login_as nil

    visit "/pl/pods/#{pod.id}/callers"
    click_on "Alerts"

    expect(page).to have_content(caller.name)
    expect(page).to have_content(match.callee.name)

    expect(match.reports.count).to eq(0)
    expect(page).to have_content('No reports')
    expect(page).not_to have_selector(".icon__alert")
  end

  it "handles no recent reports and no report frequency" do
    FactoryBot.create(:report, match: match, created_at: Date.today - 8.weeks)

    login_as nil

    visit "/pl/pods/#{pod.id}/callers"
    click_on "Alerts"

    expect(match.reports.count).to eq(1)
    expect(page).to have_content('56 days ago')
    expect(page).not_to have_selector(".icon__alert")
  end

  it "handles no recent reports, weekly report frequency" do
    FactoryBot.create(:report, match: match, created_at: Date.today - 8.weeks)
    match.report_frequency = "7"
    match.alerts_paused_until = nil
    match.save

    login_as nil

    visit "/pl/pods/#{pod.id}/callers"
    click_on "Alerts"

    expect(match.reports.count).to eq(1)
    expect(page).to have_content('56 days ago')
    expect(page).to have_selector(".icon__alert")
  end

  it "handles recent reports, weekly report frequency" do
    FactoryBot.create(:report, match: match, created_at: Date.today)
    match.report_frequency = "7"
    match.save

    login_as nil

    visit "/pl/pods/#{pod.id}/callers"
    click_on "Alerts"

    expect(match.reports.count).to eq(1)
    expect(page).to have_content("today")
    expect(page).to_not have_selector(".icon__alert")
  end

  it "handles outdated paused alert" do
    FactoryBot.create(:report, match: match, created_at: Date.today - 8.weeks)
    match.report_frequency = "7"
    match.alerts_paused_until = Date.today - 1.week
    match.save

    login_as nil

    visit "/pl/pods/#{pod.id}/callers"
    click_on "Alerts"

    expect(match.reports.count).to eq(1)
    expect(page).to have_content("56 days ago")
    expect(page).to have_selector(".icon__alert")
  end

  it "handles paused alerts" do
    FactoryBot.create(:report, match: match, created_at: Date.today)
    match.report_frequency = "7"
    match.alerts_paused_until = Date.today + 1.week
    match.save

    login_as nil

    visit "/pl/pods/#{pod.id}/callers"
    click_on "Alerts"

    expect(match.reports.count).to eq(1)
    expect(page).to have_content("today")
    expect(page).to_not have_selector(".icon__alert")
    expect(page).to have_content("Paused until")
  end
end
