class Caller < ApplicationRecord
  include HasActiveDates

  validates_associated :person

  belongs_to :person
  has_many :matches

  accepts_nested_attributes_for :person

  default_scope { includes(:person) }
  scope :with_matches, -> { includes(:matches) }

  encrypts :experience, type: :string, key: :kms_key

  def name
    person.name
  end

  def role_description
    :caller
  end

  def active_matches
    matches.filter { |m| m.active? }
  end

  def waiting?
    active? && !active_matches.present?
  end

  def waiting_since
    if waiting?
      if matches.present?
        matches.max_by(&:end_date).end_date
      else
        start_date
      end
    end
  end
end
