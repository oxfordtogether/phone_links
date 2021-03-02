class EmergencyContact < ApplicationRecord
  belongs_to :callee

  encrypts :name, type: :string, key: :kms_key
  encrypts :contact_details, type: :string, key: :kms_key
  encrypts :relationship, type: :string, key: :kms_key
end
