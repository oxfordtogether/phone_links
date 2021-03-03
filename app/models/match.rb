class Match < ApplicationRecord
  validates :caller_id, :callee_id, :pod_id, :status, presence: { message: "This field is required" }
  validates :caller_id, uniqueness: { scope: :callee_id, message: "A match for this caller and callee pair already exists" }

  options_field :status, {
    provisional: "Provisional",
    provisional_cancelled: "Provisional match cancelled",
    active: "Active",
    winding_down: "Winding down",
    ended: "Ended",
  }

  belongs_to :caller
  belongs_to :callee
  belongs_to :pod
  has_many :reports
  has_many :events
  has_many :match_status_changes

  encrypts :end_reason_notes, type: :string, key: :kms_key
  encrypts :status_change_notes, type: :string, key: :kms_key

  # TO DO: combine following methods
  def names
    "#{caller.person.first_name} - #{callee.person.first_name}"
  end

  def match_names
    "#{caller.name} & #{callee.name}"
  end

  def provisional
    status == :provisional
  end

  def provisional_cancelled
    status == :provisional_cancelled
  end

  def active
    status == :active
  end

  def winding_down
    status == :winding_down
  end

  def ended
    status == :ended
  def callee_name
    callee.name
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
end
