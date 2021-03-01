require "rails_helper"

RSpec.describe "reports", type: :system do
  let!(:pod_leader) { create(:pod_leader, active: true) }
  let!(:pod) { create(:pod, pod_leader: pod_leader) }

  let!(:callers) { create_list(:caller, 5, pod: pod) }
  let!(:callees) { create_list(:callee, 10, pod: pod) }
  let!(:matches) do
    matches = []
    (1..10).each do |_i|
      matches << create(:match, pod: pod, caller: callers.sample, callee: callees.sample)
    end

    matches
  end

  let!(:reports) do
    # less than 20 so all reports fit on one page
    create_list(:report, 2, match: matches.sample, archived_at: nil) +
      create_list(:report, 3, match: matches.sample, archived_at: FFaker::Time.date) +
      create_list(:report, 4, :legacy, legacy_pod_id: pod.id, archived_at: nil, match: nil) +
      create_list(:report, 4, :legacy, legacy_pod_id: pod.id, archived_at: FFaker::Time.date)
  end

  describe "inbox" do
    it "displays unarchived reports" do
      login_as nil

      visit "/pl/#{pod_leader.id}"
      click_on "Reports"
      expect(page).to have_current_path("/pl/#{pod_leader.id}/reports")

      unarchived_reports = reports.filter { |r| r.archived_at.nil? }.count
      expect(page).to have_content("Displaying 1 to #{unarchived_reports} of #{unarchived_reports} reports")
      expect(all("tbody tr").count).to eq(unarchived_reports)
    end

    it "navigates between reports" do
      login_as nil

      unarchived_reports = reports.filter { |r| r.archived_at.nil? }.sort_by(&:created_at).reverse

      visit "/pl/#{pod_leader.id}/reports"
      first("td", text: unarchived_reports[0].match.match_names).click

      expect(page).to have_current_path("/pl/#{pod_leader.id}/reports/#{unarchived_reports[0].id}")
      expect(page).to have_content("1 of #{unarchived_reports.count}")

      click_on(class: "next")
      expect(page).to have_current_path("/pl/#{pod_leader.id}/reports/#{unarchived_reports[1].id}")
      expect(page).to have_content("2 of #{unarchived_reports.count}")

      click_on(class: "next")
      expect(page).to have_current_path("/pl/#{pod_leader.id}/reports/#{unarchived_reports[2].id}")
      expect(page).to have_content("3 of #{unarchived_reports.count}")

      click_on(class: "previous")
      expect(page).to have_current_path("/pl/#{pod_leader.id}/reports/#{unarchived_reports[1].id}")
      expect(page).to have_content("2 of #{unarchived_reports.count}")

      click_on(class: "back")
      expect(page).to have_current_path("/pl/#{pod_leader.id}/reports")
      expect(page).to have_content("Displaying 1 to #{unarchived_reports.count} of #{unarchived_reports.count} reports")
    end

    it "archives reports" do
      login_as nil

      unarchived_reports = reports.filter { |r| r.archived_at.nil? }.sort_by(&:created_at).reverse

      visit "/pl/#{pod_leader.id}/reports/#{unarchived_reports[3].id}"
      expect(page).to have_content("4 of 6")

      find("form.archive").find("button").click
      expect(page).to have_current_path("/pl/#{pod_leader.id}/reports/#{unarchived_reports[4].id}")
      expect(page).to have_content("4 of 5")

      find("form.archive").find("button").click
      expect(page).to have_current_path("/pl/#{pod_leader.id}/reports/#{unarchived_reports[5].id}")
      expect(page).to have_content("4 of 4")

      find("form.archive").find("button").click
      expect(page).to have_current_path("/pl/#{pod_leader.id}/reports")
      expect(page).to have_content("Displaying 1 to 3 of 3 reports")

      visit "/pl/#{pod_leader.id}/reports/#{unarchived_reports[0].id}"
      expect(page).to have_content("1 of 3")

      find("form.archive").find("button").click
      expect(page).to have_current_path("/pl/#{pod_leader.id}/reports/#{unarchived_reports[1].id}")
      expect(page).to have_content("1 of 2")

      find("form.archive").find("button").click
      expect(page).to have_current_path("/pl/#{pod_leader.id}/reports/#{unarchived_reports[2].id}")
      expect(page).to have_content("1 of 1")

      find("form.archive").find("button").click
      expect(page).to have_content("No reports to display :(")
    end
  end

  describe "all" do
    it "displays all reports" do
      login_as nil

      visit "/pl/#{pod_leader.id}"
      click_on "Reports"
      click_on "All"
      expect(page).to have_current_path("/pl/#{pod_leader.id}/reports?view=all")
      expect(page).to have_content("Displaying 1 to #{reports.count} of #{reports.count} reports")
      expect(all("tbody tr").count).to eq(reports.count)
    end

    it "navigates between reports" do
      login_as nil

      sorted_reports = reports.sort_by(&:created_at).reverse

      visit "/pl/#{pod_leader.id}/reports?view=all"
      all("td", text: sorted_reports[sorted_reports.count - 1].match.match_names).last.click

      expect(page).to have_current_path("/pl/#{pod_leader.id}/reports/#{sorted_reports[sorted_reports.count - 1].id}?view=all")
      expect(page).to have_content("#{sorted_reports.count} of #{sorted_reports.count}")

      click_on(class: "previous")
      expect(page).to have_current_path("/pl/#{pod_leader.id}/reports/#{sorted_reports[sorted_reports.count - 2].id}?view=all")
      expect(page).to have_content("#{sorted_reports.count - 1} of #{sorted_reports.count}")

      click_on(class: "previous")
      expect(page).to have_current_path("/pl/#{pod_leader.id}/reports/#{sorted_reports[sorted_reports.count - 3].id}?view=all")
      expect(page).to have_content("#{sorted_reports.count - 2} of #{sorted_reports.count}")

      click_on(class: "next")
      expect(page).to have_current_path("/pl/#{pod_leader.id}/reports/#{sorted_reports[sorted_reports.count - 2].id}?view=all")
      expect(page).to have_content("#{sorted_reports.count - 1} of #{sorted_reports.count}")

      click_on(class: "back")
      expect(page).to have_current_path("/pl/#{pod_leader.id}/reports?view=all")
      expect(page).to have_content("Displaying 1 to #{sorted_reports.count} of #{sorted_reports.count} reports")
    end

    it "archives and unarchives reports" do
      login_as nil

      report = reports.filter { |r| r.archived_at.nil? }.sample

      visit "/pl/#{pod_leader.id}/reports/#{report.id}?view=all"
      find("form.archive").find("button").click
      expect(page).to have_current_path("/pl/#{pod_leader.id}/reports/#{report.id}?view=all")
      report.reload
      expect(report.archived_at).to_not eq(nil)

      find("form.unarchive").find("button").click
      expect(page).to have_current_path("/pl/#{pod_leader.id}/reports/#{report.id}?view=all")
      report.reload
      expect(report.archived_at).to eq(nil)
    end

    it "handles assigning to a match for legacy reports" do
      login_as nil

      report = reports.filter { |r| r.legacy? && r.match.nil? }.sample
      match = matches.sample
      visit "/pl/#{pod_leader.id}/reports/#{report.id}"

      select match.match_names, from: "Assign report to a match"
      click_on "Save"

      report.reload
      expect(report.match).to eq(match)

      # to do
      # select "Select...", from: "Assign report to a match"
      # click_on "Save"

      # report.reload
      # expect(report.match).to eq(nil)
    end
  end
end
