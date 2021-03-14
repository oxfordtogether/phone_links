class PodLeader < ApplicationRecord
  validates_associated :person

  options_field :status, {
    left_programme: "Left programme",
    active: "Active",
  }

  belongs_to :person
  has_one :pod
  has_many :role_status_changes

  accepts_nested_attributes_for :person

  encrypts :status_change_notes, type: :string, key: :kms_key

  default_scope { includes(:person) }
  scope :with_pod, -> { includes(pod: %i[callers callees]) }

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
