class Match < ApplicationRecord
  include HasActiveDates

  validates :caller_id, :callee_id, :pod_id, :start_date, presence: { message: "This field is required" }

  belongs_to :pod
  belongs_to :caller
  belongs_to :callee
end
