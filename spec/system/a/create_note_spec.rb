require "rails_helper"

RSpec.describe "create note", type: :system do
  let!(:callee) { create(:callee) }
  let!(:admin) { create(:admin, status: "active") }

  before do
    ENV["BYPASS_AUTH"] = "false"
  end

  after do
    ENV["BYPASS_AUTH"] = "true"
  end

  it "creates new note" do
    login_as admin.person

    visit "/a/people/#{callee.person.id}"
    click_on "New note"
    expect(page).to have_current_path("/a/people/#{callee.person.id}/notes/new")

    fill_in "Content", with: "cool thing"

    expect { click_on "Save" }.to change { Note.count }.by(1)

    expect(page).to have_current_path("/a/people/#{callee.person.id}/events")

    note = Note.last
    expect(note.person).to eq(callee.person)
    expect(note.content).to eq("cool thing")
    expect(note.created_by).to eq(admin.person)

    expect(Events::NoteChanged.count).to eq(1)
  end
end
