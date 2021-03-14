class Admin < ApplicationRecord
  validates_associated :person

  options_field :status, {
    left_programme: "Left programme",
    active: "Active",
  }

  belongs_to :person
  accepts_nested_attributes_for :person
  has_many :role_status_changes

  encrypts :status_change_notes, type: :string, key: :kms_key

  default_scope { includes(:person) }

  def name
    person.name
  end

  def role_description
    :admin
  end

  def inactive
    status == :left_programme
  end
end
