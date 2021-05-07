class Match < ApplicationRecord
  validates :caller_id, :callee_id, :pod_id, :status, presence: { message: "This field is required" }
  validates :caller_id, uniqueness: { scope: :callee_id, message: "A match for this caller and callee pair already exists" }

  options_field :status, {
    provisional: "Provisional",
    provisional_cancelled: "Provisional match cancelled",
    paused: "Paused",
    active: "Active",
    winding_down: "Winding down",
    ended: "Ended",
  }

  belongs_to :caller
  belongs_to :callee
  belongs_to :pod
  has_many :reports
  has_many :events
  has_many :match_status_changes

  scope :live, -> { where(status: %i[active paused winding_down]) }
  scope :for_caller, ->(caller_id) { where("caller_id = ?", caller_id) }
  scope :for_pod_leader, ->(pod_leader_id) { where(pod_id: PodLeader.find(pod_leader_id).accessible_pod_ids) }
  scope :with_reports, -> { includes(:reports) }

  before_save :set_status_change_datetime
  after_save :create_status_changed_record

  encrypts :status_change_notes, type: :string, key: :kms_key

  options_field :report_frequency, {
    "7": "weekly",
    "14": "fortnightly",
    "30": "monthly",
  }

  # TO DO: combine following methods
  def names
    "#{caller.person.first_name} - #{callee.person.first_name}"
  end

  def match_names
    "#{caller.name} & #{callee.name}"
  end

  def provisional
    status == :provisional
  end

  def provisional_cancelled
    status == :provisional_cancelled
  end

  def active
    status == :active
  end

  def paused
    status == :paused
  end

  def winding_down
    status == :winding_down
  end

  def ended
    status == :ended
  end

  def callee_name
    callee.name
  end

  def pod_mismatch
    # handle caller/callee not having a pod
    return "Caller and Callee are not assigned to a pod, match is assigned to #{pod.name}." unless caller.pod.present? && callee.pod.present?
    return "Caller is not assigned to a pod, match is assigned to #{pod.name}." unless caller.pod.present?
    return "Callee is not assigned to a pod, match is assigned to #{pod.name}." unless callee.pod.present?

    # handle caller/callee being part of a different pod
    return "Caller is assigned to #{caller.pod.name}, callee is assigned to #{callee.pod.name}, match is assigned to #{pod.name}." unless caller.pod == pod && callee.pod == pod
    return "Caller is assigned to #{caller.pod.name}, match is assigned to #{pod.name}." unless caller.pod == pod
    return "Callee is assigned to #{callee.pod.name}, match is assigned to #{pod.name}." unless callee.pod == pod

    false
  end

  def set_status_change_datetime
    if status_changed? || status_change_notes_changed?
      self.status_change_datetime = DateTime.now
    end
  end

  def create_status_changed_record
    first_status_change = match_status_changes.count == 0 && status_change_datetime.present?
    subsequent_status_change = match_status_changes.count != 0 && (match_status_changes.sort_by(&:created_at).last.datetime != status_change_datetime)

    if first_status_change || subsequent_status_change
      MatchStatusChange.create(
        match: self,
        created_by_id: Current.person_id,
        status: status,
        datetime: status_change_datetime,
        notes: status_change_notes,
      )
    end
  end

  def support_index
    feeling_to_numeric_hash = {awful: -2, bad: -1, neutral: 0, good: 1, great: 1}

    if reports.last(10).filter { |r| r.caller_feeling.present? }.count >= 3
      reports.sort_by(&:created_at).last(10).map(&:caller_feeling).map { |v| feeling_to_numeric_hash[v] }.compact.sum
    else
      nil
    end
  end
end
