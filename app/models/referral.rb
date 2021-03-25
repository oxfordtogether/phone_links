class Referral < ApplicationRecord
  validates :referrer_type, :first_name, :last_name, :phone, :address_postcode, :address_line_1, :address_town, :reason_for_referral, :confirm_consent, :confirm_data_shared, :confirm_data_protection, presence: { message: "This field is required" }

  options_field :status, {
    unread: "Unread",
    in_progress: "In progress",
    duplicate: "Duplicate",
    approved: "Approved",
    rejected: "Rejected",
  }

  options_field :referrer_type, {
    professional: "A professional referring someone",
    friend_or_family_or_contact: "Referring a friend, family member or contact",
    referring_self: 'I would like to receive a phone call myself',
  }

  options_field :age_bracket, {
    age_18_35: "18-35",
    age_36_59: "36-59",
    age_60_75: "60-74",
    age_75_plus: "75+",
  }

  after_save :create_status_changed_record

  belongs_to :callee, optional: true
  has_many :referral_status_changes

  encrypts :referrer_organisation, type: :string, key: :kms_key
  encrypts :referrer_full_name, type: :string, key: :kms_key
  encrypts :referrer_phone, type: :string, key: :kms_key
  encrypts :referrer_email, type: :string, key: :kms_key
  encrypts :first_name, type: :string, key: :kms_key
  encrypts :last_name, type: :string, key: :kms_key
  encrypts :phone, type: :string, key: :kms_key
  encrypts :date_of_birth, type: :date, key: :kms_key
  encrypts :address_line_1, type: :string, key: :kms_key
  encrypts :address_line_2, type: :string, key: :kms_key
  encrypts :address_town, type: :string, key: :kms_key
  encrypts :address_postcode, type: :string, key: :kms_key
  encrypts :reason_for_referral, type: :string, key: :kms_key
  encrypts :additional_needs, type: :string, key: :kms_key
  encrypts :other_information, type: :string, key: :kms_key
  encrypts :other_support, type: :string, key: :kms_key
  encrypts :languages, type: :string, key: :kms_key
  encrypts :emergency_contact_name, type: :string, key: :kms_key
  encrypts :emergency_contact_relationship, type: :string, key: :kms_key
  encrypts :emergency_contact_details, type: :string, key: :kms_key
  encrypts :notes, type: :string, key: :kms_key

  def name
    "#{first_name} #{last_name}"
  end

  def new_callee
    Callee.new(
      person_attributes: {
        first_name: first_name,
        last_name: last_name,
        phone: phone,
        address_line_1: address_line_1,
        address_line_2: address_line_2,
        address_town: address_town,
        address_postcode: address_postcode,
        age_bracket: age_bracket
      },
      reason_for_referral: reason_for_referral,
      additional_needs: additional_needs,
      other_information: other_information,
      languages_notes: languages,
      emergency_contacts_attributes: [
        {
          name: emergency_contact_name,
          contact_details: emergency_contact_details,
          relationship: emergency_contact_relationship
        }
      ],
      referrals: [self],
      status: 'waiting_list'
    )
  end
  # date_of_birth
  # other_support

  private

  def create_status_changed_record
    ReferralStatusChange.create(
      referral: self,
      created_by_id: Current.person_id,
      status: status,
      datetime: status_changed_at,
      notes: notes,
    )
  end
end
