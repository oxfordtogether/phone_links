class Match < ApplicationRecord
  validates :caller_id, :callee_id, presence: { message: "This field is required" }

  belongs_to :pod
  belongs_to :caller
  belongs_to :callee
end
