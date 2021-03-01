class Report < ApplicationRecord
  belongs_to :match, optional: true
  has_many :events

  encrypts :summary, type: :string, key: :kms_key

  encrypts :legacy_caller_email, type: :string, key: :kms_key
  encrypts :legacy_caller_name, type: :string, key: :kms_key
  encrypts :legacy_callee_name, type: :string, key: :kms_key
  encrypts :legacy_time_and_date, type: :string, key: :kms_key
  encrypts :concerns_notes, type: :string, key: :kms_key
  encrypts :legacy_outcome, type: :string, key: :kms_key

  def legacy?
    legacy_caller_email.present?
  end

  def create_events!
    Events::ReportEventCreator.new(self).create_events!
  end
end
