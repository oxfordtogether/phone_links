require "rails_helper"

RSpec.describe "show match", type: :system do
  let!(:caller) { create(:caller, status: "active") }
  let!(:callee) { create(:callee, status: "active") }
  let!(:match) { create(:match, caller: caller, callee: callee, status: "active") }

  let!(:match_1) { create(:match, caller: create(:caller), status: "active") }

  it "doesn't give access to callees that caller isn't matched to" do
    login_as nil

    expect do
      visit "/c/#{caller.id}/matches/#{match_1.id}"
      page.has_text? "Wait for page to load"
    end.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "only gives access to active, paused and winding down matches" do
    login_as nil

    Match.statuses.keys.each do |status|
      match.status = status
      match.save!


      if %w[active paused winding_down].include?(status)
        visit "/c/#{caller.id}/matches/#{match.id}"
        expect(page).to have_content(match.callee.name)
      else
        expect do
          visit "/c/#{caller.id}/matches/#{match.id}"
          page.has_text? "Wait for page to load"
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
