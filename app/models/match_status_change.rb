class MatchStatusChange < ApplicationRecord
  options_field :status, {
    provisional: "Provisional",
    provisional_cancelled: "Provisional match cancelled",
    active: "Active",
    winding_down: "Winding down",
    ended: "Ended",
  }

  belongs_to :match
  belongs_to :created_by, class_name: "Person"

  encrypts :notes, type: :string, key: :kms_key
end
