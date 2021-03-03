require "rails_helper"

RSpec.describe "MatchEventCreator", type: :model do
  let!(:caller) { create(:caller) }
  let!(:callee) { create(:callee) }
  let!(:match) { create(:match, start_date: "2019-01-01", caller: caller, callee: callee, end_date: nil) }

  it "works" do
    Events::MatchEventCreator.new(match).create_events!
    expect(Event.count).to eq(1)
    expect(Event.active.first.type).to eq("Events::MatchCreated")
    expect(Event.active.first.person_id).to eq(callee.person.id)
    expect(Event.active.first.caller_id).to eq(caller.id)
    expect(Event.active.first.start_date).to eq(match.start_date.strftime("%Y-%m-%d"))

    match.reload # just added an event to match, reload to ensure it's available
    match.start_date = "2020-01-01"
    match.save!
    Events::MatchEventCreator.new(match).create_events!
    expect(Event.count).to eq(2)
    expect(Event.active.count).to eq(1)
    expect(Event.active.first.type).to eq("Events::MatchCreated")
    expect(Event.active.first.person_id).to eq(callee.person.id)
    expect(Event.active.first.caller_id).to eq(caller.id)
    expect(Event.active.first.start_date).to eq("2020-01-01")

    match.reload
    match.end_date = "2020-02-01"
    match.save!
    Events::MatchEventCreator.new(match).create_events!
    expect(Event.count).to eq(3)
    expect(Event.active.count).to eq(2)
    expect(Event.active.last.type).to eq("Events::MatchEnded")
    expect(Event.active.last.person_id).to eq(callee.person.id)
    expect(Event.active.last.caller_id).to eq(caller.id)
    expect(Event.active.last.start_date).to eq("2020-01-01")
    expect(Event.active.last.end_date).to eq("2020-02-01")

    match.reload
    match.end_date = "2020-02-02"
    match.save!
    Events::MatchEventCreator.new(match).create_events!
    expect(Event.count).to eq(4)
    expect(Event.active.count).to eq(2)
    expect(Event.active.last.type).to eq("Events::MatchEnded")
    expect(Event.active.last.person_id).to eq(callee.person.id)
    expect(Event.active.last.caller_id).to eq(caller.id)
    expect(Event.active.last.start_date).to eq("2020-01-01")
    expect(Event.active.last.end_date).to eq("2020-02-02")
  end
end
