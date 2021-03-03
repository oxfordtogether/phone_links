class Caller < ApplicationRecord
  validates_associated :person

  belongs_to :person
  belongs_to :pod, optional: true
  has_many :matches

  accepts_nested_attributes_for :person

  default_scope { includes(:person) }
  scope :with_matches, -> { includes(:matches) }

  encrypts :experience, type: :string, key: :kms_key

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

  def ended_matches
    matches.filter { |m| m.no_longer_active? }
  end

  def active_matches
    matches.filter { |m| m.active? }
  end

  def provisional_matches
    matches.filter { |m| m.provisional }
  end

  def on_waiting_list
    !added_to_waiting_list.nil?
  end
end
