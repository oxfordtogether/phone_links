class Match < ApplicationRecord
  include HasActiveDates

  validates :caller_id, :callee_id, :start_date, presence: { message: "This field is required" }

  belongs_to :caller
  belongs_to :callee
  belongs_to :pod

  encrypts :end_reason_notes, type: :string, key: :kms_key

  def pod_mismatch
    # handle caller/callee not having a pod
    return "Caller and Callee are not assigned to a pod. Go to their profile pages to assign them to pod: #{pod.name}." unless caller.pod.present? && callee.pod.present?
    return "Caller is not assigned to a pod. Go to their profile page to assign them to pod: #{pod.name}." unless caller.pod.present?
    return "Callee is not assigned to a pod. Go to their profile page to assign them to pod: #{pod.name}." unless callee.pod.present?

    # handle caller/callee being part of a different pod
    return "Caller is assigned to #{caller.pod.name}, callee is assigned to #{callee.pod.name}. Go to their profile page to reassign them to pod: #{pod.name}" unless caller.pod == pod && callee.pod == pod
    return "Caller is assigned to #{caller.pod.name}. Go to their profile page to reassign them to pod: #{pod.name}" unless caller.pod == pod
    return "Callee is assigned to #{callee.pod.name}. Go to their profile page to reassign them to pod: #{pod.name}" unless callee.pod == pod

    false
  end
end
