require "rails_helper"

RSpec.describe "NoteEventCreator", type: :model do
  let!(:note) { create(:note, content: "hello") }

  it "works" do
    Events::NoteEventCreator.new(note).create_events!
    expect(Event.count).to eq(1)
    expect(Event.active.first.content).to eq("hello")
    expect(Event.active.first.status).to eq("created")

    note.reload
    note.content = "goodbye"
    Events::NoteEventCreator.new(note).create_events!
    expect(Event.count).to eq(2)
    expect(Event.active.count).to eq(1)
    expect(Event.active.first.content).to eq("goodbye")
    expect(Event.active.first.status).to eq("created")

    note.reload
    note.content = "goodbye 123"
    note.save!
    Events::NoteEventCreator.new(note).create_events!
    expect(Event.count).to eq(3)
    expect(Event.active.count).to eq(1)
    expect(Event.active.first.content).to eq("goodbye 123")
    expect(Event.active.first.status).to eq("edited")

    note.reload
    note.deleted_at = DateTime.now
    note.save!
    Events::NoteEventCreator.new(note).create_events!
    expect(Event.count).to eq(4)
    expect(Event.active.count).to eq(1)
    expect(Event.active.first.content).to eq("goodbye 123")
    expect(Event.active.first.status).to eq("deleted")
  end
end
