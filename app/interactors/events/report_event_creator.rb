module Events
  class ReportEventCreator
    attr_reader :report

    def initialize(report)
      @report = report
    end

    def existing_events
      @existing_events ||= report.events.select(&:active?)
    end

    def existing_event
      return @existing_event if @existing_event

      events = existing_events.select(&:report_submitted?)
      raise "More than one joined event for report #{report.id}" if events.length > 1

      @existing_event = events.first
    end

    def create_events!
      if !existing_event
        ReportSubmitted.create_from_report!(report)
      elsif !existing_event.matches_report?(report)

        ActiveRecord::Base.transaction do
          new_event = ReportSubmitted.create_from_report!(report)
          existing_event&.update(replacement_event_id: new_event.id)
        end
      end
    end
  end
end
