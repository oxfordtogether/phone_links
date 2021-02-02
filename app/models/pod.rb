class Pod < ApplicationRecord
  validates :name, presence: { message: "This field is required" }
  validates_uniqueness_of :name, message: "This field must be unique, given value already taken"

  has_many :matches
  belongs_to :pod_leader, optional: true

  scope :with_matches, lambda {
    includes(matches: [
               { caller: :person }, { callee: :person }
             ])
  }
end
