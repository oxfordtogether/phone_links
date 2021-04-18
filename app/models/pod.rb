class Pod < ApplicationRecord
  validates :name, :safeguarding_lead_id, presence: { message: "This field is required" }
  validates_uniqueness_of :name, message: "This field must be unique, given value already taken"

  has_many :callers
  has_many :callees
  has_many :matches
  belongs_to :pod_leader, optional: true
  belongs_to :safeguarding_lead, class_name: "Person"
  has_many :pod_supporters

  accepts_nested_attributes_for :pod_supporters

  scope :with_matches, lambda {
    includes(callers: [
               :person,
               { matches: { callee: :person } },
             ])
  }
  scope :for_pod_leader, ->(pod_leader_id) { where(id: PodLeader.find(pod_leader_id).accessible_pod_ids) }

  def live_matches
    matches.live
  end

  def name_and_leader
    if pod_leader
      "#{name} (#{pod_leader.name})"
    else
      "#{name} (No pod leader assigned)"
    end
  end
end
