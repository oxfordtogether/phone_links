class PodSupporter < ApplicationRecord
  validates :pod_id, :supporter_id, presence: { message: "This field is required" }

  belongs_to :pod
  belongs_to :supporter, class_name: "PodLeader"
end
