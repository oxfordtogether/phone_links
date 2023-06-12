class Person < ApplicationRecord
  validates :first_name, :last_name, presence: { message: "This field is required" }

  before_update :set_flag_change_datetime
  after_update :create_person_flag_changed_record

  def self.titles
    %w[MR MRS MISS MS MX DR PROFESSOR]
  end

  has_one :callee
  has_one :caller
  has_one :pod_leader
  has_one :admin
  has_many :notes
  has_many :events
  has_many :person_flag_changes

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

  options_field :age_bracket, {
    age_18_35: "18-35",
    age_36_59: "36-59",
    age_60_75: "60-74",
    age_75_plus: "75+",
  }

  has_encrypted :title, type: :string, key: :kms_key
  has_encrypted :first_name, type: :string, key: :kms_key
  has_encrypted :last_name, type: :string, key: :kms_key
  has_encrypted :phone, type: :string, key: :kms_key
  has_encrypted :email, type: :string, key: :kms_key
  has_encrypted :address_line_1, type: :string, key: :kms_key
  has_encrypted :address_line_2, type: :string, key: :kms_key
  has_encrypted :address_town, type: :string, key: :kms_key
  has_encrypted :address_postcode, type: :string, key: :kms_key
  has_encrypted :flag_change_notes, type: :string, key: :kms_key

  def name
    "#{first_name} #{last_name}"
  end

  def initials
    "#{first_name[0]}#{last_name[0]}".upcase
  end

  def roles
    [callee, caller, admin, pod_leader].filter { |p| !p.nil? }
  end

  def missing_email
    !email.present?
  end

  def signed_up
    auth0_id.present?
  end

  def invite_needed
    !signed_up && !invite_email_sent_at.present?
  end

  def invite_sent
    !signed_up && invite_email_sent_at.present?
  end

  def set_flag_change_datetime
    self.flag_change_datetime = Time.now if flag_in_progress_changed? || flag_change_notes_changed?
  end

  def create_person_flag_changed_record
    first_flag_change = person_flag_changes.empty? && flag_change_datetime.present?
    flag_changed_on_save = !person_flag_changes.empty? && person_flag_changes.max_by(&:created_at).datetime != flag_change_datetime

    if first_flag_change || flag_changed_on_save
      PersonFlagChange.create(
        person: self,
        flag_in_progress: flag_in_progress,
        notes: flag_change_notes,
        created_by: @current_user,
        created_by_id: Current.person_id,
        datetime: flag_change_datetime,
      )
    end
  end
end
