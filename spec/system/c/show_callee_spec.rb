require "rails_helper"

RSpec.describe "show callee", type: :system do
  let!(:caller) { create(:caller, status: "active") }
  let!(:callee) { create(:callee, status: "active") }
  let!(:match) { create(:match, caller: caller, callee: callee) }

  let!(:callee_1) { create(:callee, status: "active") }

  before do
    ENV["BYPASS_AUTH"] = "false"
  end

  after do
    ENV["BYPASS_AUTH"] = "true"
  end

  it "doesn't give access to callees that caller isn't matched to" do
    login_as caller.person

    visit "/c/#{caller.id}/callees/#{callee_1.id}"
    expect(page).to have_content("Invalid permissions")
  end

  it "only gives access to active, paused and winding down matches" do
    login_as caller.person

    Match.statuses.keys.each do |status|
      match.status = status
      match.save!

      visit "/c/#{caller.id}/callees/#{callee.id}"

      if %w[active paused winding_down].include?(status)
        expect(page).to have_content(match.callee.name)
      else
        expect(page).to have_content("Invalid permissions")
      end
    end
  end
end
