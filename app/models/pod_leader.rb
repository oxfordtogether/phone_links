class PodLeader < ApplicationRecord
  validates :start_date, presence: { message: "This field is required" }
  validates_associated :person

  belongs_to :person
  has_many :pods

  accepts_nested_attributes_for :person

  default_scope { includes(:person) }

  def name
    person.name
  end
end
