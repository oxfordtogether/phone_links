require "rails_helper"

RSpec.describe "delete note", type: :system do
  let!(:pod) { create(:pod, pod_leader: nil) }
  let!(:callee) { create(:callee) }
  let!(:pod_leader) { create(:pod_leader, person: create(:person, email: "pod_leader@test.com", auth0_id: "234"), status: "active", pods: [pod]) }
  let!(:note) do
    note = create(:note, person: callee.person, created_by: pod_leader.person, deleted_at: nil)
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
    login_as pod_leader.person

    visit "/pl/people/#{callee.person.id}"
    expect(page).not_to have_content("Edit note")

    note_edit_path = "/pl/notes/#{note.id}/edit"
    find(:xpath, "//a[@href='#{note_edit_path}']").click

    expect(current_path).to eq("/pl/notes/#{note.id}/edit")
    expect(page).to have_content("Edit note")

    expect { click_on "Delete" }.to change { Events::NoteChanged.count }.by(1)

    expect(page).to have_current_path("/pl/people/#{callee.person.id}")

    note.reload
    expect(note.deleted_at).not_to eq(nil)
  end
end
