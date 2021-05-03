require "rails_helper"

RSpec.describe "delete note", type: :system do
  let!(:callee) { create(:callee) }
  let!(:admin) { create(:admin, person: create(:person, email: "admin@test.com", auth0_id: "234"), status: "active") }
  let!(:note) { create(:note, person: callee.person, created_by: admin.person, deleted_at: nil) }

  before do
    ENV["BYPASS_AUTH"] = "false"
  end

  after do
    ENV["BYPASS_AUTH"] = "true"
    Current.person_id = nil
  end

  it "deletes note" do
    login_as admin.person

    visit "/a/people/#{callee.person.id}"
    expect(page).not_to have_content("Edit note")

    note_edit_path = "/a/notes/#{note.id}/edit"
    find(:xpath, "//a[@href='#{note_edit_path}']").click

    expect(current_path).to eq("/a/notes/#{note.id}/edit")
    expect(page).to have_content("Edit note")

    click_on "Delete"

    expect(page).to have_current_path("/a/people/#{callee.person.id}/events")

    note.reload
    expect(note.deleted_at).not_to eq(nil)
  end
end
