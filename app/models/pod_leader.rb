class PodLeader < ApplicationRecord
  validates_associated :person

  belongs_to :person
  has_many :pods

  accepts_nested_attributes_for :person

  default_scope { includes(:person) }

  def name
    person.name
  end

  def role_description
    :pod_leader
  end
end
