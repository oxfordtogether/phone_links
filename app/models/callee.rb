class Callee < ApplicationRecord
  validates_associated :person

  belongs_to :person
  belongs_to :pod, optional: true
  has_many :matches

  accepts_nested_attributes_for :person

  default_scope { includes(:person) }
  scope :with_matches, -> { includes(:matches) }

  encrypts :reason_for_referral, type: :string, key: :kms_key
  encrypts :living_arrangements, type: :string, key: :kms_key
  encrypts :other_information, type: :string, key: :kms_key
  encrypts :additional_needs, type: :string, key: :kms_key
  encrypts :flag_note, type: :string, key: :kms_key

  def name
    person.name
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

  def active_matches
    matches.filter { |m| m.active? }
  end

  def waiting?
    active && !active_matches.present?
  end

  def waiting_since
    if waiting?
      if matches.present?
        matches.max_by(&:end_date).end_date
      else
        # not quite the right defn
        created_at
      end
    end
  end
end
