class Report < ApplicationRecord
  belongs_to :match, optional: true
  has_many :events

  encrypts :summary, type: :string, key: :kms_key
  encrypts :no_answer_notes, type: :string, key: :kms_key

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

  options_field :caller_feeling, {
    great: "great",
    good: "good",
    neutral: "neutral",
    bad: "bad",
    awful: "awful",
  }

  options_field :callee_feeling, {
    great: "great",
    good: "good",
    neutral: "neutral",
    bad: "bad",
    awful: "awful",
  }

  scope :for_pod, lambda { |pod_id|
                    where(match_id: Pod.find(pod_id).matches.map(&:id))
                      .or(Report.where(legacy_pod_id: pod_id))
                      .order(created_at: :desc)
                  }
  scope :inbox, -> { where(archived_at: nil) }
  scope :newest_first, -> { order(created_at: :desc) }

  def legacy?
    legacy_caller_email.present? || legacy_caller_name.present?
  end
end
