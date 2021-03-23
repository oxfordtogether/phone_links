class Note < ApplicationRecord
  validates :content, presence: { message: "This field is required" }
  validates_associated :person # TO DO: add created_at here fails

  belongs_to :person
  belongs_to :created_by, class_name: "Person"
  has_many :events

  encrypts :content, type: :string, key: :kms_key

  scope :for_people, ->(people_ids) { where(person_id: people_ids) }

  def create_events!
    Events::NoteEventCreator.new(self).create_events!
  end

  def status
    if deleted_at
      "deleted"
    elsif created_at == updated_at
      "created"
    else
      "edited"
    end
  end
end
