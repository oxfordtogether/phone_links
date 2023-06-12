class EmergencyContact < ApplicationRecord
  belongs_to :callee

  has_encrypted :name, type: :string, key: :kms_key
  has_encrypted :contact_details, type: :string, key: :kms_key
  has_encrypted :relationship, type: :string, key: :kms_key
end
