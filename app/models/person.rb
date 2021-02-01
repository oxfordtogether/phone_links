class Person < ApplicationRecord
  validates :first_name, :last_name, presence: { message: "This field is required" }

  has_many :callees
  has_many :callers
  has_many :pod_leaders
  has_many :admins

  scope :with_roles, lambda {
    includes(
      :callees,
      :callers,
      :pod_leaders,
      :admins
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

  def name
    "#{first_name} #{last_name}"
  end

  def roles
    callees + callers + pod_leaders + admins
  end
end
