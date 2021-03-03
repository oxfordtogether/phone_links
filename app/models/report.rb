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

  options_field :duration, {
    less_than_fifteen: "less than 15 minutes",
    fifteen_thirty: "15 - 30 minutes",
    thirty_sixty: "30 minutes - 1 hour",
    over_sixty: "Over 1 hour",
    no_answer: "I did not get through",
  }
  options_field :caller_confidence, {
    one: "one",
    two: "two",
    three: "three",
    four: "four",
    five: "five",
  }

  def legacy?
    legacy_caller_email.present?
  end
end
