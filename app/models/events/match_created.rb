module Events
  class MatchCreated < Event
    def match_created?
      true
    end

    validates_presence_of :match

    non_sensitive_data_attr :caller_id
    non_sensitive_data_attr :start_date
    non_sensitive_data_attr :pending
    non_sensitive_data_attr :pod_id
    non_sensitive_data_attr :pod_name
    sensitive_data_attr :caller_name

    def self.create_from_match!(match)
      create!(
        occurred_at: match.created_at,
        match: match,
        person_id: match.callee.person.id,
        caller_id: match.caller.id,
        caller_name: match.caller.name,
        start_date: match.start_date,
        pending: match.pending,
        pod_id: match.pod.id,
        pod_name: match.pod.name,
      )
    end

    def matches_match?(match)
      occurred_at == match.created_at &&
        caller_id == match.caller.id &&
        caller_name == match.caller.name &&
        start_date == match.start_date.strftime("%Y-%m-%d") &&
        pending == match.pending &&
        pod_id == match.pod.id &&
        pod_name == match.pod.name
    end
  end
end
