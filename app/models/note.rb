class Note < ApplicationRecord
  validates :content, presence: { message: "This field is required" }
  validates_associated :person # TO DO: add created_at here fails

  belongs_to :person
  belongs_to :created_by, class_name: "Person"
  has_many :events

  encrypts :content, type: :string, key: :kms_key

  def create_events!
    Events::NoteEventCreator.new(self).create_events!
  end

  def status
    if deleted_at
      "DELETED"
    elsif created_at == updated_at
      "CREATED"
    else
      "EDITED"
    end
  end
end
