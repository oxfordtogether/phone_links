class Caller < ApplicationRecord
  validates_associated :person

  before_save :set_capacity_last_updated

  after_save :update_matches, if: :saved_change_to_status?
  def update_matches
    if status == :left_programme
      matches.each do |m|
        if m.status != :ended
          m.status = :ended
          m.status_change_datetime = Time.now()
          m.status_change_notes = "Caller left programme"
          m.save
        end
      end
    end
  end

  options_field :status, {
    waiting_list: "On waiting list",
    left_programme: "Left programme",
    active: "Active",
  }

  options_field :check_in_frequency, {
    weekly: "Weekly",
    fortnightly: "Fortnightly",
    monthly: "Monthly",
    every_2_months: "Every 2 months",
    every_3_months: "Every 3 months",
    every_6_months: "Every 6 months",
    check_ins_not_required: "Not required",
  }

  belongs_to :person
  belongs_to :pod, optional: true
  has_many :matches
  has_many :role_status_changes

  accepts_nested_attributes_for :person

  default_scope { includes(:person) }
  scope :with_matches, -> { includes(:matches) }
  scope :for_pod, ->(pod_id) { where(pod_id: pod_id) }
  scope :for_pod_leader, ->(pod_leader_id) { where(pod_id: PodLeader.find(pod_leader_id).accessible_pod_ids) }
  scope :login_enabled, -> { where(status: :active)}
  scope :active, -> { where(status: :active)}

  encrypts :experience, type: :string, key: :kms_key
  encrypts :status_change_notes, type: :string, key: :kms_key
  encrypts :languages_notes, type: :string, key: :kms_key
  encrypts :capacity_notes, type: :string, key: :kms_key

  def name
    person.name
  end

  def name_pod_capacity
    # to do: add capacity
    if pod
      "#{person.name} (Pod: #{pod.name})"
    else
      "#{person.name} (not assigned to a pod)"
    end
  end

  def role_description
    :caller
  end

  def provisional_matches
    matches.filter { |m| m.provisional }
  end

  def provisional_cancelled_matches
    matches.filter { |m| m.provisional_cancelled }
  end

  def active_matches
    matches.filter { |m| m.active }
  end

  def paused_matches
    matches.filter { |m| m.paused }
  end

  def winding_down_matches
    matches.filter { |m| m.winding_down }
  end

  def ended_matches
    matches.filter { |m| m.ended }
  end

  def live_matches
    active_matches + paused_matches + winding_down_matches
  end

  def active
    status == :active
  end

  def waiting_list
    status == :waiting_list
  end

  def left_programme
    status == :left_programme
  end

  def live
    active || waiting_list
  end

  def inactive
    status == :left_programme
  end

  def set_capacity_last_updated
    self.capacity_last_updated = Time.now if has_capacity_changed? || capacity_notes_changed?
  end
end
