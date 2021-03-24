require "rails_helper"

RSpec.describe "create note", type: :system do
  let!(:pod) { create(:pod, pod_leader: nil) }
  let!(:callee) { create(:callee, status: "active", pod: pod) }
  let!(:pod_leader) { create(:pod_leader, status: "active", pods: [pod]) }

  before do
    ENV["BYPASS_AUTH"] = "false"
  end

  after do
    ENV["BYPASS_AUTH"] = "true"
  end

  it "creates new note" do
    login_as pod_leader.person

    visit "/pl/people/#{callee.person.id}"
    click_on "New note"
    expect(page).to have_current_path("/pl/people/#{callee.person.id}/notes/new")

    fill_in "Content", with: "cool thing"

    expect { click_on "Save" }.to change { Note.count }.by(1)

    expect(page).to have_current_path("/pl/people/#{callee.person.id}")

    note = Note.last
    expect(note.person).to eq(callee.person)
    expect(note.content).to eq("cool thing")
    expect(note.created_by).to eq(pod_leader.person)

    expect(Events::NoteChanged.count).to eq(1)
  end
end
