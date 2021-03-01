module Events
  class ReportSubmitted < Event
    def report_submitted?
      true
    end

    validates_presence_of :report

    non_sensitive_data_attr :caller_id
    non_sensitive_data_attr :duration
    non_sensitive_data_attr :callee_state
    non_sensitive_data_attr :datetime
    non_sensitive_data_attr :legacy_date
    non_sensitive_data_attr :legacy_time
    non_sensitive_data_attr :archived_at
    sensitive_data_attr :legacy_time_and_date
    sensitive_data_attr :legacy_duration
    sensitive_data_attr :summary

    def self.create_from_report!(report)
      create!(
        occurred_at: report.created_at,
        report: report,
        person_id: report&.match&.callee&.person&.id,
        caller_id: report&.match&.caller&.id,
        duration: report.duration,
        callee_state: report.callee_state,
        datetime: report.datetime,
        legacy_date: report.legacy_date,
        legacy_time: report.legacy_time,
        archived_at: report.archived_at,
        legacy_time_and_date: report.legacy_time_and_date,
        legacy_duration: report.legacy_duration,
        summary: report.summary,
      )
    end

    def matches_report?(report)
      occurred_at == report.created_at &&
        person_id == report&.match&.callee&.person&.id &&
        caller_id == report&.match&.caller&.id &&
        duration == report.duration &&
        callee_state == report.callee_state &&
        datetime == report.datetime.strftime("%Y-%m-%dT%H:%M:%S.%LZ") &&
        legacy_date == report.legacy_date &&
        legacy_time == report.legacy_time &&
        archived_at == report.archived_at.strftime("%Y-%m-%dT%H:%M:%S.%LZ") &&
        legacy_time_and_date == report.legacy_time_and_date &&
        legacy_duration == report.legacy_duration &&
        summary == report.summary
    end
  end
end
