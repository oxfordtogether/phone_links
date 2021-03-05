class RoleStatusChange < ApplicationRecord
  validates :status, :datetime, presence: { message: "This field is required" }

  options_field :status, {
    waiting_list: "On waiting list",
    left_programme: "Left programme",
    active: "Active",
  }

  belongs_to :created_by, class_name: "Person", optional: true

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
