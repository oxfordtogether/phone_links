require "rails_helper"

RSpec.describe "edit note", type: :system do
  let!(:pod) { create(:pod, pod_leader: nil) }
  let!(:callee) { create(:callee, status: "active", pod: pod) }
  let!(:pod_leader) { create(:pod_leader, person: create(:person, email: "pod_leader@test.com", auth0_id: "123"), status: "active", pods: [pod]) }
  let!(:admin) { create(:admin, person: create(:person, email: "admin@test.com", auth0_id: "234"), status: "active") }

  let!(:note) do
    note = create(:note, person: callee.person, created_by: pod_leader.person, deleted_at: nil)
    note.create_events!
    note
  end

  let!(:note_2) do
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

  it "edits note" do
    login_as pod_leader.person

    visit "/pl/people/#{callee.person.id}"
    expect(page).not_to have_content("Edit note")

    note_edit_path = "/pl/notes/#{note.id}/edit"
    find(:xpath, "//a[@href='#{note_edit_path}']").click

    expect(current_path).to eq("/pl/notes/#{note.id}/edit")
    expect(page).to have_content("Edit note")

    fill_in "Content", with: "cool thing"

    expect { click_on "Save" }.to change { Events::NoteChanged.count }.by(1)

    expect(page).to have_current_path("/pl/people/#{callee.person.id}")

    note.reload
    expect(note.person).to eq(callee.person)
    expect(note.content).to eq("cool thing")
    expect(note.created_by).to eq(pod_leader.person)
  end

  it "doesn't allow editing someone elses note" do
    login_as pod_leader.person

    visit "/pl/people/#{callee.person.id}"

    note_edit_path = "/pl/notes/#{note_2.id}/edit"
    page.assert_no_selector(:xpath, "//a[@href='#{note_edit_path}']")

    expect do
      visit "/pl/notes/#{note_2.id}/edit"
      page.has_text? "Wait for page to load"
    end.to raise_error(ActiveRecord::RecordNotFound)
  end
end
