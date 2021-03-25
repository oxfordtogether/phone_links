class ReferralStatusChange < ApplicationRecord
  belongs_to :referral
  belongs_to :created_by, class_name: "Person"

  encrypts :notes, type: :string, key: :kms_key

  options_field :status, {
    unread: "Unread",
    in_progress: "In progress",
    duplicate: "Duplicate",
    approved: "Approved",
    rejected: "Rejected",
  }
end
