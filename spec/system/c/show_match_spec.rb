require "rails_helper"

RSpec.describe "show match", type: :system do
  let!(:caller) { create(:caller, status: "active", person: create(:person, auth0_id: '123')) }
  let!(:callee) { create(:callee, status: "active") }
  let!(:match) { create(:match, caller: caller, callee: callee, status: "active") }

  let!(:match_1) { create(:match, caller: create(:caller), status: "active") }

  before do
    ENV["BYPASS_AUTH"] = "false"
  end

  after do
    ENV["BYPASS_AUTH"] = "true"
  end

  it "doesn't give access to callees that caller isn't matched to" do
    login_as caller.person

    expect do
      visit "/c/matches/#{match_1.id}"
      page.has_text? "Wait for page to load"
    end.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "only gives access to active, paused and winding down matches" do
    login_as caller.person

    Match.statuses.keys.each do |status|
      match.status = status
      match.save!

      if %w[active paused winding_down].include?(status)
        visit "/c/matches/#{match.id}"
        expect(page).to have_content(match.callee.name)
      else
        expect do
          visit "/c/matches/#{match.id}"
          page.has_text? "Wait for page to load"
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
