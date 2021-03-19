class SafeguardingConcernStatusChange < ApplicationRecord
  belongs_to :safeguarding_concern
  belongs_to :created_by, class_name: "Person"

  encrypts :notes, type: :string, key: :kms_key

  options_field :status, {
    unread: "unread",
    in_progress: "in progress",
    archived: "archived",
  }
end
