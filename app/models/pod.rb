class Pod < ApplicationRecord
  validates :name, presence: { message: "This field is required" }
  validates_uniqueness_of :name, message: "This field must be unique, given value already taken"

  has_many :callers
  has_many :callees
  belongs_to :pod_leader, optional: true

  scope :with_matches, lambda {
    includes(callers: [
               :person,
               { matches: { callee: :person } },
             ])
  }

  def active_matches
    callers.map { |c| c.active_matches }.flatten
  end

  def matches
    callers.map { |c| c.matches }.flatten
  end
end
