class Callee < ApplicationRecord
  include HasActiveDates

  validates :start_date, presence: { message: "This field is required" }
  validates_associated :person

  belongs_to :person
  has_many :matches

  accepts_nested_attributes_for :person

  default_scope { includes(:person) }

  def name
    person.name
  end

  def role_description
    :callee
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
