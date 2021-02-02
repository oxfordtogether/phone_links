class Caller < ApplicationRecord
  validates :start_date, presence: { message: "This field is required" }
  validates_associated :person

  belongs_to :person
  accepts_nested_attributes_for :person

  default_scope { includes(:person) }

  def name
    person.name
  end

  def waiting?
    # active and no match
    true # to do
  end
end
