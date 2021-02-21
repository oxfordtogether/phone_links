module Events
  class NoteChanged < Event
    validates_presence_of :note

    non_sensitive_data_attr :status
    sensitive_data_attr :content

    def self.create_from_note!(note)
      create!(
        note: note,
        occurred_at: note.created_at,
        created_by_id: note.created_by_id,
        person_id: note.person_id,
        content: note.content,
        status: note.status,
      )
    end

    def matches_note?(note)
      occurred_at == note.created_at &&
        created_by_id == note.created_by_id &&
        person_id == note.person_id &&
        content == note.content &&
        status == note.status
    end
  end
end
