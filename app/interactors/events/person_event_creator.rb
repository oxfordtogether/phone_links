module Events
  class PersonEventCreator
    attr_reader :person

    def initialize(person)
      @person = person
    end

    def create_events!
      FlagChanged.create_from_person!(person) if person.flag_updated_at != last_flag_event_at
    end

    def last_flag_event_at
      person.events.select(&:flag_changed?).max_by(&:occurred_at)&.occurred_at
    end
  end
end
