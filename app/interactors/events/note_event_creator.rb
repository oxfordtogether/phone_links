module Events
  class NoteEventCreator
    attr_reader :note

    def initialize(note)
      @note = note
    end

    def current_event
      return @current_event if @current_event

      active_events = note.events.select(&:active?)
      raise "More than one active event for note #{note.id}" if active_events.length > 1

      @current_event = active_events.first
    end

    def create_events!
      if !current_event
        NoteChanged.create_from_note!(note)
      elsif !current_event.matches_note?(note)
        ActiveRecord::Base.transaction do
          new_event = NoteChanged.create_from_note!(note)
          current_event&.update(replacement_event_id: new_event.id)
        end
      end
    end
  end
end
