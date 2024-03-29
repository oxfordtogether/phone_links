class PersonFlagChange < ApplicationRecord
  validates :datetime, presence: { message: "This field is required" }

  belongs_to :created_by, class_name: "Person", optional: true
  belongs_to :person

  encrypts :notes, type: :string, key: :kms_key
end
