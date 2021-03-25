class ReferralsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :referrals do |t|

      t.datetime :submitted_at, null: false

      t.string :referrer_type
      t.text :referrer_organisation_ciphertext
      t.text :referrer_full_name_ciphertext
      t.text :referrer_phone_ciphertext
      t.text :referrer_email_ciphertext

      t.text :first_name_ciphertext, null: false
      t.text :last_name_ciphertext, null: false
      t.text :phone_ciphertext, null: false

      t.string :age_bracket
      t.text :date_of_birth_ciphertext

      t.text :address_line_1_ciphertext
      t.text :address_line_2_ciphertext
      t.text :address_town_ciphertext
      t.text :address_postcode_ciphertext

      t.text :reason_for_referral_ciphertext
      t.text :additional_needs_ciphertext
      t.text :other_information_ciphertext
      t.text :other_support_ciphertext

      t.text :languages_ciphertext

      t.text :emergency_contact_name_ciphertext
      t.text :emergency_contact_relationship_ciphertext
      t.text :emergency_contact_details_ciphertext

      t.references :callee, foreign_key: true

      t.string :status, null: false
      t.text :notes_ciphertext
      t.datetime :status_changed_at, null: false

      t.boolean :confirm_consent, null: false
      t.boolean :confirm_data_shared, null: false
      t.boolean :confirm_data_protection, null: false

      t.timestamps
    end

    create_table :referral_status_changes do |t|
      t.timestamps

      t.references :referral, null: false, foreign_key: true

      t.string :status, null: false
      t.text :notes_ciphertext, null: true
      t.datetime :datetime, null: false
      t.references :created_by, null: false, foreign_key: { to_table: :people }
    end
  end
end
