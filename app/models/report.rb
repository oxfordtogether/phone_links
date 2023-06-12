class Report < ApplicationRecord
  belongs_to :match, optional: true
  has_many :events

  has_encrypted :summary, type: :string, key: :kms_key
  has_encrypted :no_answer_notes, type: :string, key: :kms_key

  has_encrypted :legacy_caller_email, type: :string, key: :kms_key
  has_encrypted :legacy_caller_name, type: :string, key: :kms_key
  has_encrypted :legacy_callee_name, type: :string, key: :kms_key
  has_encrypted :legacy_time_and_date, type: :string, key: :kms_key
  has_encrypted :concerns_notes, type: :string, key: :kms_key
  has_encrypted :legacy_outcome, type: :string, key: :kms_key

  options_field :duration, {
    no_answer: "I did not get through",
    less_than_fifteen: "less than 15 minutes",
    fifteen_thirty: "15 - 30 minutes",
    thirty_sixty: "30 minutes - 1 hour",
    over_sixty: "Over 1 hour",
  }

  options_field :caller_feeling, {
    awful: "awful",
    bad: "bad",
    neutral: "neutral",
    good: "good",
    great: "great",
  }

  options_field :callee_feeling, {
    awful: "awful",
    bad: "bad",
    neutral: "neutral",
    good: "good",
    great: "great",
  }

  scope :for_pod, lambda { |pod_id|
                    where(match_id: Pod.find(pod_id).matches.map(&:id))
                      .or(Report.where(legacy_pod_id: pod_id))
                      .order(created_at: :desc)
                  }
  scope :inbox, -> { where(archived_at: nil) }
  scope :newest_first, -> { order(created_at: :desc) }
  scope :for_match, ->(match_id) { where(match_id: match_id) }
  scope :for_caller, ->(caller_id) { where(match_id: Caller.find(caller_id).matches) }
  scope :for_month, ->(month_start) { where("cast(date_trunc('month', created_at) as date) = '#{month_start.strftime('%Y-%m-%d')}'") }

  def legacy?
    legacy_caller_email.present? || legacy_caller_name.present?
  end
end
