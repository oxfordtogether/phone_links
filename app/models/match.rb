class Match < ApplicationRecord
  include HasActiveDates

  validates :caller_id, :callee_id, :pod_id, :start_date, presence: { message: "This field is required" }

  def self.end_reasons
    %w[NOT_A_FIT CALLEE_DECEASED CALLEE_LEFT_PROGRAM CALLER_LEFT_PROGRAM CREATED_BY_MISTAKE OTHER]
  end

  belongs_to :caller
  belongs_to :callee
  belongs_to :pod
  has_many :reports
  has_many :events

  encrypts :end_reason_notes, type: :string, key: :kms_key

  # TO DO: combine following methods
  def names
    "#{caller.person.first_name} - #{callee.person.first_name}"
  end

  def match_names
    "#{caller.name} & #{callee.name}"
  end

  def pod_mismatch
    # handle caller/callee not having a pod
    return "Caller and Callee are not assigned to a pod, match is assigned to #{pod.name}." unless caller.pod.present? && callee.pod.present?
    return "Caller is not assigned to a pod, match is assigned to #{pod.name}." unless caller.pod.present?
    return "Callee is not assigned to a pod, match is assigned to #{pod.name}." unless callee.pod.present?

    # handle caller/callee being part of a different pod
    return "Caller is assigned to #{caller.pod.name}, callee is assigned to #{callee.pod.name}, match is assigned to #{pod.name}." unless caller.pod == pod && callee.pod == pod
    return "Caller is assigned to #{caller.pod.name}, match is assigned to #{pod.name}." unless caller.pod == pod
    return "Callee is assigned to #{callee.pod.name}, match is assigned to #{pod.name}." unless callee.pod == pod

    false
  end

  def create_events!
    Events::MatchEventCreator.new(self).create_events!
  end
end
