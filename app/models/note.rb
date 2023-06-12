class Note < ApplicationRecord
  validates :content, presence: { message: "This field is required" }
  validates_associated :person # TO DO: add created_at here fails

  belongs_to :person
  belongs_to :created_by, class_name: "Person"

  options_field :note_type, {
    admin_check_in: "Check-in (by admin)",
    pod_leader_check_in: "Check-in (by pod leader)",
    caller_callee_initiated: "Caller/callee got in touch",
    pod_meeting: "Pod meeting",
    newsletter: "Newsletter sent out",
    other: "Note: other",
  }

  has_encrypted :content, type: :string, key: :kms_key

  scope :for_people, ->(people_ids) { where(person_id: people_ids) }

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
