class Callee < ApplicationRecord
  validates_associated :person

  options_field :status, {
    waiting_list: "On waiting list",
    left_programme: "Left programme",
    active: "Active",
  }

  belongs_to :person
  belongs_to :pod, optional: true
  has_many :matches
  has_many :emergency_contacts
  has_many :role_status_changes

  accepts_nested_attributes_for :person
  accepts_nested_attributes_for :emergency_contacts

  default_scope { includes(:person) }
  scope :with_matches, -> { includes(:matches) }

  encrypts :reason_for_referral, type: :string, key: :kms_key
  encrypts :living_arrangements, type: :string, key: :kms_key
  encrypts :other_information, type: :string, key: :kms_key
  encrypts :additional_needs, type: :string, key: :kms_key
  encrypts :call_frequency, type: :string, key: :kms_key
  encrypts :status_change_notes, type: :string, key: :kms_key

  def name
    person.name
  end

  def initials
    person.initials
  end

  def name_and_pod
    if pod
      "#{person.name} (Pod: #{pod.name})"
    else
      "#{person.name} (not assigned to a pod)"
    end
  end

  def role_description
    :callee
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

  def waiting_list
    status == :waiting_list
  end

  def inactive
    status == :left_programme
  end
end
