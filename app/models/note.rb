class Note < ApplicationRecord
  belongs_to :callee
  belongs_to :created_by, class_name: "Person"

  encrypts :content, type: :string, key: :kms_key
end
