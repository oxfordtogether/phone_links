class Person < ApplicationRecord
  validates :first_name, :last_name, :email, presence: { message: "This field is required" }

  def self.titles
    %w[MR MRS MISS MS MX DR PROFESSOR]
  end

  has_one :callee
  has_one :caller
  has_one :pod_leader
  has_one :admin
  has_many :notes
  has_many :events

  accepts_nested_attributes_for :admin
  accepts_nested_attributes_for :caller
  accepts_nested_attributes_for :callee
  accepts_nested_attributes_for :pod_leader

  scope :with_roles, lambda {
    includes(
      :callee,
      :caller,
      :pod_leader,
      :admin,
    )
  }

  encrypts :title, type: :string, key: :kms_key
  encrypts :first_name, type: :string, key: :kms_key
  encrypts :last_name, type: :string, key: :kms_key
  encrypts :phone, type: :string, key: :kms_key
  encrypts :email, type: :string, key: :kms_key
  encrypts :address_line_1, type: :string, key: :kms_key
  encrypts :address_line_2, type: :string, key: :kms_key
  encrypts :address_town, type: :string, key: :kms_key
  encrypts :address_postcode, type: :string, key: :kms_key
  encrypts :flag_note, type: :string, key: :kms_key

  def name
    "#{first_name} #{last_name}"
  end

  def roles
    [callee, caller, admin, pod_leader].filter { |p| !p.nil? }
  end

  def create_events!
    Events::PersonEventCreator.new(self).create_events!
  end
end
