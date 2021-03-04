class RoleStatusChange < ApplicationRecord
  options_field :status, {
    waiting_list: "On waiting list",
    left_programme: "Left programme",
    active: "Active",
    caller_role_inactive: "No longer a caller",
    pod_leader_role_inactive: "No longer a pod leader",
    admin_role_inactive: "No longer a admin",
  }

  belongs_to :created_by, class_name: "Person"

  belongs_to :callee, optional: true
  belongs_to :caller, optional: true
  belongs_to :pod_leader, optional: true
  belongs_to :admin, optional: true

  has_exclusive :owning_object, from: %i[
    callee caller pod_leader admin
  ]

  encrypts :notes, type: :string, key: :kms_key

  def role
    if callee
      callee
    elsif caller
      caller
    elsif pod_leader
      pod_leader
    else
      admin
    end
  end

  def role_description
    role.role_description
  end
end
