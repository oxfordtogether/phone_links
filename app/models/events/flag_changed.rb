module Events
  class FlagChanged < Event
    def flag_changed?
      true
    end

    validates_presence_of :person

    non_sensitive_data_attr :flag_in_progress
    sensitive_data_attr :notes

    def started?
      !!flag_in_progress
    end

    def finished?
      !flag_in_progress
    end

    def self.create_from_person!(person)
      return unless person.flag_updated_at

      create!(
        occurred_at: person.flag_updated_at,
        person: person,
        created_by_id: person.flag_updated_by_id,
        flag_in_progress: person.flag_in_progress,
        notes: person.flag_note,
      )
    end
  end
end
