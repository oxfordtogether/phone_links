require "rails_helper"

RSpec.describe "ReportEventCreator", type: :model do
  let!(:caller) { create(:caller) }
  let!(:callee) { create(:callee) }
  let!(:match) { create(:match, caller: caller, callee: callee) }
  let!(:report) { create(:report, match: match) }

  it "works" do
    Events::ReportEventCreator.new(report).create_events!
    expect(Event.count).to eq(1)

    Events::ReportEventCreator.new(report.reload).create_events!
    expect(Event.count).to eq(1)
  end
end
