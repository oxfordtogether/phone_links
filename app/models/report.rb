class Report < ApplicationRecord
  belongs_to :match
  encrypts :summary, type: :string, key: :kms_key
end
