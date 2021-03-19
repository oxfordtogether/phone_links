class SafeguardingConcern < ApplicationRecord
  validates :created_by_id, :person_id, :concerns, :status, :status_changed_at, presence: { message: "This field is required" }

  after_save :create_status_changed_record

  belongs_to :person
  belongs_to :created_by, class_name: "Person"
  has_many :safeguarding_concern_status_changes

  encrypts :concerns, type: :string, key: :kms_key
  encrypts :status_changed_notes, type: :string, key: :kms_key

  options_field :status, {
    unread: "unread",
    in_progress: "in progress",
    archived: "archived",
  }

  private

  def create_status_changed_record
    SafeguardingConcernStatusChange.create(
      safeguarding_concern: self,
      created_by_id: Current.person_id,
      status: status,
      datetime: status_changed_at,
      notes: status_changed_notes,
    )
  end
end
