class MatchStatusChange < ApplicationRecord
  validates :status, :datetime, presence: { message: "This field is required" }

  options_field :status, {
    provisional: "Provisional",
    provisional_cancelled: "Provisional match cancelled",
    paused: "Paused",
    active: "Active",
    winding_down: "Winding down",
    ended: "Ended",
  }

  belongs_to :match
  belongs_to :created_by, class_name: "Person", optional: true

  encrypts :notes, type: :string, key: :kms_key
end
