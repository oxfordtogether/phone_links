require "rails_helper"

RSpec.describe "PodLeaderDataFetcher", type: :helper do
  let!(:admin) { create(:admin, status: "active") }

  let!(:pods) { create_list(:pod, 3, pod_leader: nil) }

  let!(:pod_leader_1) { create(:pod_leader, status: "active", pods: pods[0..1]) }
  let!(:pod_leader_2) { create(:pod_leader, status: "active", pods: [pods[2]]) }

  let!(:pod_leader_3) do
    pod_leader = create(:pod_leader, status: "active", pods: [])
    pod_supporters = [
      create(:pod_supporter, pod: pods[1], supporter: pod_leader),
      create(:pod_supporter, pod: pods[2], supporter: pod_leader),
    ]
    pod_leader
  end

  let!(:pod_leader_4) do
    pod_leader = create(:pod_leader, status: "active", pods: [])
    pod_supporters = [
      create(:pod_supporter, pod: pods[0], supporter: pod_leader),
    ]
    pod_leader
  end

  let!(:na) do
    pods.each do |pod|
      callers = create_list(:caller, 3, pod: pod)
      callees = create_list(:callee, 3, pod: pod)

      (0..2).to_a.each do |i|
        match = create(:match, pod: pod, caller: callers[i], callee: callees[i])
        create_list(:report, 2, match: match, legacy_pod_id: pod.id)
      end

      create_list(:report, 4, match: nil, legacy_pod_id: pod.id)

      (0..2).to_a.each do |i|
        create(:note, person: callees[i].person, created_by: admin.person)
        create(:note, person: callees[i].person, created_by: pod_leader_1.person)
        create(:note, person: callees[i].person, created_by: pod_leader_2.person)
        create(:note, person: callees[i].person, created_by: pod_leader_3.person)
        create(:note, person: callees[i].person, created_by: pod_leader_4.person)
      end
    end
  end

  let!(:callers) { Caller.all }
  let!(:callees) { Callee.all }
  let!(:reports) { Report.all }
  let!(:matches) { Match.all }
  let!(:notes) { Note.all }

  it "gives access to everything for admins" do
    Current.person_id = admin.person_id

    fetcher = Pl::PodLeaderDataFetcher.new(admin: admin)

    expect(fetcher.pod_leader(pod_leader_1.id)).to eq(pod_leader_1)
    expect(fetcher.pod_leader(pod_leader_2.id)).to eq(pod_leader_2)

    pods.each do |pod|
      expect(fetcher.pod(pod.id)).to eq(pod)

      expect(fetcher.all_reports(pod.id).count).to eq(reports.filter { |r| r.legacy_pod_id == pod.id || pod.matches.include?(r.match) }.count)
      expect(fetcher.inbox_reports(pod.id).count).to eq(reports.filter { |r| (r.legacy_pod_id == pod.id || pod.matches.include?(r.match)) && r.archived_at.nil? }.count)

      expect(fetcher.callers(pod.id).count).to eq(pod.callers.count)
      expect(fetcher.callees(pod.id).count).to eq(pod.callees.count)
    end

    report = reports.sample
    expect(fetcher.report(report.id)).to eq(report)

    caller = callers.sample
    expect(fetcher.caller(caller.id)).to eq(caller)

    callee = callees.sample
    expect(fetcher.callee(callee.id)).to eq(callee)

    person = Person.all.sample
    expect(fetcher.person(person.id)).to eq(person)

    match = matches.sample
    expect(fetcher.match(match.id)).to eq(match)

    note = notes.filter { |n| n.created_by == admin.person }.sample
    expect(fetcher.note(note.id)).to eq(note)

    note = notes.filter { |n| n.created_by == pod_leader_1.person }.sample
    expect do
      fetcher.note(note.id)
    end.to raise_error(ActiveRecord::RecordNotFound)

    Current.person_id = nil
  end

  it "restricts access for pod leader who leads a pod" do
    Current.person_id = pod_leader_1.person_id

    fetcher = Pl::PodLeaderDataFetcher.new(pod_leader: pod_leader_1)

    expect(fetcher.pod_leader(pod_leader_1.id)).to eq(pod_leader_1)
    expect do
      fetcher.pod_leader(pod_leader_2.id)
    end.to raise_error(ActiveRecord::RecordNotFound)

    pod_leader_1.pods.each do |pod|
      expect(fetcher.pod(pod.id)).to eq(pod)

      expect(fetcher.all_reports(pod.id).count).to eq(reports.filter { |r| r.legacy_pod_id == pod.id || pod.matches.include?(r.match) }.count)
      expect(fetcher.inbox_reports(pod.id).count).to eq(reports.filter { |r| (r.legacy_pod_id == pod.id || pod.matches.include?(r.match)) && r.archived_at.nil? }.count)

      expect(fetcher.callers(pod.id).count).to eq(pod.callers.count)
      expect(fetcher.callees(pod.id).count).to eq(pod.callees.count)

      match = pod.matches.sample
      expect(fetcher.match(match.id)).to eq(match)

      caller = pod.callers.sample
      expect(fetcher.caller(caller.id)).to eq(caller)

      callee = pod.callees.sample
      expect(fetcher.callee(callee.id)).to eq(callee)

      pod_people = pod.callers.map(&:person) + pod.callees.map(&:person)
      person = pod_people.sample
      expect(fetcher.person(person.id)).to eq(person)

      note = pod_people.map(&:notes).flatten.filter { |n| n.created_by == pod_leader_1.person }.sample
      expect(fetcher.note(note.id)).to eq(note)

      note = pod_people.map(&:notes).flatten.filter { |n| n.created_by == admin.person }.sample
      expect do
        fetcher.note(note.id)
      end.to raise_error(ActiveRecord::RecordNotFound)

      report = Report.where(legacy_pod_id: pod.id).sample
      expect(fetcher.report(report.id)).to eq(report)

      report = Report.where(match_id: pod.matches.map(&:id)).sample
      expect(fetcher.report(report.id)).to eq(report)
    end

    pod_leader_2.pods.each do |pod|
      expect do
        fetcher.pod(pod.id)
      end.to raise_error(ActiveRecord::RecordNotFound)

      expect do
        fetcher.all_reports(pod.id)
      end.to raise_error(ActiveRecord::RecordNotFound)
      expect do
        fetcher.inbox_reports(pod.id)
      end.to raise_error(ActiveRecord::RecordNotFound)

      expect do
        fetcher.callers(pod.id)
      end.to raise_error(ActiveRecord::RecordNotFound)
      expect do
        fetcher.callees(pod.id)
      end.to raise_error(ActiveRecord::RecordNotFound)

      match = pod.matches.sample
      expect do
        fetcher.match(match.id)
      end.to raise_error(ActiveRecord::RecordNotFound)

      caller = pod.callers.sample
      expect do
        fetcher.caller(caller.id)
      end.to raise_error(ActiveRecord::RecordNotFound)
      callee = pod.callees.sample
      expect do
        fetcher.callee(callee.id)
      end.to raise_error(ActiveRecord::RecordNotFound)

      pod_people = pod.callers.map(&:person) + pod.callees.map(&:person)
      person = pod_people.sample
      expect do
        fetcher.person(person.id)
      end.to raise_error(ActiveRecord::RecordNotFound)

      note = pod_people.map(&:notes).flatten.sample
      expect do
        fetcher.note(note.id)
      end.to raise_error(ActiveRecord::RecordNotFound)

      report = Report.where(legacy_pod_id: pod.id).sample
      expect do
        fetcher.report(report.id)
      end.to raise_error(ActiveRecord::RecordNotFound)

      report = Report.where(match_id: pod.matches).sample
      expect do
        fetcher.report(report.id)
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    Current.person_id = nil
  end

  it "restricts access for pod supporter" do
    Current.person_id = pod_leader_3.person_id

    fetcher = Pl::PodLeaderDataFetcher.new(pod_leader: pod_leader_3)

    expect(fetcher.pod_leader(pod_leader_3.id)).to eq(pod_leader_3)
    expect do
      fetcher.pod_leader(pod_leader_4.id)
    end.to raise_error(ActiveRecord::RecordNotFound)

    pods[1..2].each do |pod| # pods for which pod_leader_3 is a supporter
      expect(fetcher.pod(pod.id)).to eq(pod)

      expect(fetcher.all_reports(pod.id).count).to eq(reports.filter { |r| r.legacy_pod_id == pod.id || pod.matches.include?(r.match) }.count)
      expect(fetcher.inbox_reports(pod.id).count).to eq(reports.filter { |r| (r.legacy_pod_id == pod.id || pod.matches.include?(r.match)) && r.archived_at.nil? }.count)

      expect(fetcher.callers(pod.id).count).to eq(pod.callers.count)
      expect(fetcher.callees(pod.id).count).to eq(pod.callees.count)

      match = pod.matches.sample
      expect(fetcher.match(match.id)).to eq(match)

      caller = pod.callers.sample
      expect(fetcher.caller(caller.id)).to eq(caller)

      callee = pod.callees.sample
      expect(fetcher.callee(callee.id)).to eq(callee)

      pod_people = pod.callers.map(&:person) + pod.callees.map(&:person)
      person = pod_people.sample
      expect(fetcher.person(person.id)).to eq(person)

      note = pod_people.map(&:notes).flatten.filter { |n| n.created_by == pod_leader_3.person }.sample
      expect(fetcher.note(note.id)).to eq(note)

      note = pod_people.map(&:notes).flatten.filter { |n| n.created_by == admin.person }.sample
      expect do
        fetcher.note(note.id)
      end.to raise_error(ActiveRecord::RecordNotFound)

      report = Report.where(legacy_pod_id: pod.id).sample
      expect(fetcher.report(report.id)).to eq(report)

      report = Report.where(match_id: pod.matches.map(&:id)).sample
      expect(fetcher.report(report.id)).to eq(report)
    end

    [pods[0]].each do |pod|
      expect do
        fetcher.pod(pod.id)
      end.to raise_error(ActiveRecord::RecordNotFound)

      expect do
        fetcher.all_reports(pod.id)
      end.to raise_error(ActiveRecord::RecordNotFound)
      expect do
        fetcher.inbox_reports(pod.id)
      end.to raise_error(ActiveRecord::RecordNotFound)

      expect do
        fetcher.callers(pod.id)
      end.to raise_error(ActiveRecord::RecordNotFound)
      expect do
        fetcher.callees(pod.id)
      end.to raise_error(ActiveRecord::RecordNotFound)

      match = pod.matches.sample
      expect do
        fetcher.match(match.id)
      end.to raise_error(ActiveRecord::RecordNotFound)

      caller = pod.callers.sample
      expect do
        fetcher.caller(caller.id)
      end.to raise_error(ActiveRecord::RecordNotFound)
      callee = pod.callees.sample
      expect do
        fetcher.callee(callee.id)
      end.to raise_error(ActiveRecord::RecordNotFound)

      pod_people = pod.callers.map(&:person) + pod.callees.map(&:person)
      person = pod_people.sample
      expect do
        fetcher.person(person.id)
      end.to raise_error(ActiveRecord::RecordNotFound)

      note = pod_people.map(&:notes).flatten.sample
      expect do
        fetcher.note(note.id)
      end.to raise_error(ActiveRecord::RecordNotFound)

      report = Report.where(legacy_pod_id: pod.id).sample
      expect do
        fetcher.report(report.id)
      end.to raise_error(ActiveRecord::RecordNotFound)

      report = Report.where(match_id: pod.matches).sample
      expect do
        fetcher.report(report.id)
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    Current.person_id = nil
  end
end
