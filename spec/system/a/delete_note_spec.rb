require "rails_helper"

RSpec.describe "edit note", type: :system do
  let!(:callee) { create(:callee) }
  let!(:admin) { create(:admin, status: "active") }
  let!(:note) do
    note = create(:note, person: callee.person, created_by: admin.person, deleted_at: nil)
    note.create_events!
    note
  end

  before do
    ENV["BYPASS_AUTH"] = "false"
  end

  after do
    ENV["BYPASS_AUTH"] = "true"
  end

  it "deletes note" do
    login_as admin.person

    visit "/a/people/#{callee.person.id}"
    expect(page).not_to have_content("Edit note")

    note_edit_path = "/a/notes/#{note.id}/edit"
    find(:xpath, "//a[@href='#{note_edit_path}']").click

    expect(current_path).to eq("/a/notes/#{note.id}/edit")
    expect(page).to have_content("Edit note")

    expect { click_on "Delete" }.to change { Events::NoteChanged.count }.by(1)

    expect(page).to have_current_path("/a/people/#{callee.person.id}/events")

    note.reload
    expect(note.deleted_at).not_to eq(nil)
  end
end
