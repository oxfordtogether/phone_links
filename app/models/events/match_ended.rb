module Events
  class MatchEnded < Event
    def match_ended?
      true
    end

    validates_presence_of :match

    non_sensitive_data_attr :caller_id
    non_sensitive_data_attr :start_date
    non_sensitive_data_attr :end_date
    non_sensitive_data_attr :pending
    non_sensitive_data_attr :pod_id
    non_sensitive_data_attr :pod_name
    non_sensitive_data_attr :end_reason
    sensitive_data_attr :caller_name
    sensitive_data_attr :end_reason_notes

    def self.create_from_match!(match)
      create!(
        occurred_at: match.created_at,
        match: match,
        person_id: match.callee.person.id,
        caller_id: match.caller.id,
        caller_name: match.caller.name,
        start_date: match.start_date,
        end_date: match.end_date,
        pending: match.pending,
        pod_id: match.pod.id,
        pod_name: match.pod.name,
        end_reason: match.end_reason,
        end_reason_notes: match.end_reason_notes,
      )
    end

    def matches_match?(match)
      occurred_at == match.created_at &&
        caller_id == match.caller.id &&
        caller_name == match.caller.name &&
        start_date == match.start_date.strftime("%Y-%m-%d") &&
        end_date == match.end_date.strftime("%Y-%m-%d") &&
        pending == match.pending &&
        pod_id == match.pod.id &&
        pod_name == match.pod.name &&
        end_reason == match.end_reason &&
        end_reason_notes == match.end_reason_notes
    end
  end
end
