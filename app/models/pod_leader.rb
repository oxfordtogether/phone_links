class PodLeader < ApplicationRecord
  validates_associated :person

  options_field :status, {
    left_programme: "Left programme",
    active: "Active",
  }

  belongs_to :person
  has_many :pods
  has_many :role_status_changes
  has_many :pod_supporters, foreign_key: "supporter"

  accepts_nested_attributes_for :person

  encrypts :status_change_notes, type: :string, key: :kms_key

  default_scope { includes(:person) }
  scope :with_pods, -> { includes(pods: %i[callers callees]) }

  def accessible_pod_ids
    pods.map(&:id) + pod_supporters.map(&:pod_id)
  end

  def name
    person.name
  end

  def name_and_pod
    if pod
      "#{person.name} (Pod: #{pod.name})"
    else
      "#{person.name} (not assigned to a pod)"
    end
  end

  def role_description
    :pod_leader
  end

  def inactive
    status == :left_programme
  end
end
