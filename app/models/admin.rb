class Admin < ApplicationRecord
  validates_associated :person

  belongs_to :person
  accepts_nested_attributes_for :person

  default_scope { includes(:person) }

  def name
    person.name
  end

  def role_description
    :admin
  end
end
