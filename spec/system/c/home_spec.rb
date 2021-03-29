require "rails_helper"

RSpec.describe "homepage", type: :system do
  let!(:caller) { create(:caller, status: "active") }

  let!(:callee_1) { create(:callee, status: "active") }
  let!(:callee_2) { create(:callee, status: "active") }

  it "works for caller without a pod" do
    caller.pod = nil
    caller.save!

    login_as nil

    visit "/c/callers/#{caller.id}"
    expect(page).to have_content("You're not currently assigned to a pod")
  end

  it "works for caller without a match" do
    login_as nil

    visit "/c/callers/#{caller.id}"
    expect(page).to have_content("You don't have any active matches at the moment")
  end

  it "only displays active, paused and winding down matches" do
    match = create(:match, caller: caller, callee: callee_1)

    login_as nil

    Match.statuses.keys.each do |status|
      match.status = status
      match.save!

      visit "/c/callers/#{caller.id}"

      if %w[active paused winding_down].include?(status)
        expect(page).to have_content(match.callee.name)
      else
        expect(page).to_not have_content(match.callee.name)
      end
    end
  end
end
