class Pl::PodLeaderDataFetcher
  def initialize(admin: nil, pod_leader: nil)
    @admin = admin
    @pod_leader = pod_leader
  end

  def pod_leader(pod_leader_id)
    if @admin.present?
      PodLeader.find(pod_leader_id)
    else
      PodLeader.where(id: @pod_leader.id).find(pod_leader_id)
    end
  end

  def pod(pod_id)
    if @admin.present?
      Pod.find(pod_id)
    else
      Pod.for_pod_leader(@pod_leader.id).find(pod_id)
    end
  end

  def all_reports(pod_id)
    pod(pod_id) unless @admin.present?

    Report.for_pod(pod_id).newest_first
  end

  def inbox_reports(pod_id)
    pod(pod_id) unless @admin.present?

    Report.for_pod(pod_id).inbox.newest_first
  end

  def report(report_id)
    if @admin.present?
      Report.find(report_id)
    else
      report = Report.find(report_id)
      pod_id = report.match&.pod_id || report.legacy_pod_id

      pod(pod_id)

      report
    end
  end

  def callers(pod_id)
    pod(pod_id) unless @admin.present?

    Caller.for_pod(pod_id)
  end

  def callees(pod_id)
    pod(pod_id) unless @admin.present?

    Callee.for_pod(pod_id)
  end

  def caller(caller_id)
    if @admin.present?
      Caller.find(caller_id)
    else
      Caller.for_pod_leader(@pod_leader.id).find(caller_id)
    end
  end

  def callee(callee_id)
    if @admin.present?
      Callee.find(callee_id)
    else
      Callee.for_pod_leader(@pod_leader.id).find(callee_id)
    end
  end

  def person(person_id)
    if @admin.present?
      Person.find(person_id)
    else
      callers = Caller.for_pod_leader(@pod_leader.id)
      callees = Callee.for_pod_leader(@pod_leader.id)

      records = (callers.where(person_id: person_id) + callees.where(person_id: person_id))
      raise ActiveRecord::RecordNotFound if records.empty?

      records.first.person
    end
  end

  def note(note_id)
    records = Note.where(id: note_id).where(created_by_id: Current.person_id)
    raise ActiveRecord::RecordNotFound if records.empty?

    note = records.first

    if @admin.present?
      note
    else
      person(note.person_id)
      note
    end
  end

  def match(match_id)
    if @admin.present?
      Match.find(match_id)
    else
      Match.for_pod_leader(@pod_leader.id).find(match_id)
    end
  end
end
