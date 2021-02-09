class PodLeader < ApplicationRecord
  validates_associated :person

  belongs_to :person
  has_one :pod

  accepts_nested_attributes_for :person

  default_scope { includes(:person) }

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
end
