module Events
  class MatchEventCreator
    attr_reader :match

    def initialize(match)
      @match = match
    end

    def existing_events
      @existing_events ||= match.events.select(&:active?)
    end

    def existing_created_event
      return @existing_created_event if @existing_created_event

      created_events = existing_events.select(&:match_created?)
      raise "More than one joined event for match #{match.id}" if created_events.length > 1

      @existing_created_event = created_events.first
    end

    def existing_ended_event
      return @existing_ended_event if @existing_ended_event

      ended_events = existing_events.select(&:match_ended?)
      raise "More than one left event for match #{match.id}" if ended_events.length > 1

      @existing_ended_event = ended_events.first
    end

    def create_events!
      if !existing_created_event
        debugger
        MatchCreated.create_from_match!(match)
      elsif !existing_created_event.matches_match?(match)
        debugger

        ActiveRecord::Base.transaction do
          new_event = MatchCreated.create_from_match!(match)
          existing_created_event&.update(replacement_event_id: new_event.id)
        end
      end

      if match.end_date && !existing_ended_event
        debugger

        MatchEnded.create_from_match!(match)
      elsif match.end_date && !existing_ended_event.matches_match?(match)
        debugger

        ActiveRecord::Base.transaction do
          new_event = MatchEnded.create_from_match!(match)
          existing_ended_event&.update(replacement_event_id: new_event.id)
        end
      end
    end
  end
end
