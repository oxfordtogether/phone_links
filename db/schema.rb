# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_06_12_141810) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "person_id", null: false
    t.text "status_change_notes_ciphertext"
    t.string "status", null: false
    t.datetime "status_change_datetime"
    t.index ["person_id"], name: "index_admins_on_person_id"
  end

  create_table "callees", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "person_id", null: false
    t.text "reason_for_referral_ciphertext"
    t.text "living_arrangements_ciphertext"
    t.text "other_information_ciphertext"
    t.text "additional_needs_ciphertext"
    t.bigint "pod_id"
    t.text "call_frequency_ciphertext"
    t.date "added_to_waiting_list"
    t.text "status_change_notes_ciphertext"
    t.string "status", null: false
    t.datetime "status_change_datetime"
    t.text "languages_notes_ciphertext"
    t.text "summary_ciphertext"
    t.index ["person_id"], name: "index_callees_on_person_id"
    t.index ["pod_id"], name: "index_callees_on_pod_id"
  end

  create_table "callers", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "person_id", null: false
    t.text "experience_ciphertext"
    t.bigint "pod_id"
    t.date "added_to_waiting_list"
    t.text "status_change_notes_ciphertext"
    t.string "status", null: false
    t.datetime "status_change_datetime"
    t.text "languages_notes_ciphertext"
    t.string "check_in_frequency"
    t.date "next_check_in"
    t.boolean "pod_whatsapp_membership"
    t.boolean "has_capacity"
    t.text "capacity_notes_ciphertext"
    t.datetime "capacity_last_updated"
    t.index ["person_id"], name: "index_callers_on_person_id"
    t.index ["pod_id"], name: "index_callers_on_pod_id"
  end

  create_table "emergency_contacts", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "callee_id", null: false
    t.text "name_ciphertext", null: false
    t.text "contact_details_ciphertext", null: false
    t.text "relationship_ciphertext", null: false
    t.index ["callee_id"], name: "index_emergency_contacts_on_callee_id"
  end

  create_table "events", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "type"
    t.string "version"
    t.datetime "occurred_at"
    t.text "sensitive_data_ciphertext"
    t.jsonb "non_sensitive_data", default: {}, null: false
    t.bigint "person_id", null: false
    t.bigint "replacement_event_id"
    t.bigint "created_by_id"
    t.bigint "match_id"
    t.bigint "report_id"
    t.bigint "note_id"
    t.index ["created_by_id"], name: "index_events_on_created_by_id"
    t.index ["match_id"], name: "index_events_on_match_id"
    t.index ["note_id"], name: "index_events_on_note_id"
    t.index ["person_id"], name: "index_events_on_person_id"
    t.index ["replacement_event_id"], name: "index_events_on_replacement_event_id"
    t.index ["report_id"], name: "index_events_on_report_id"
  end

  create_table "match_status_changes", force: :cascade do |t|
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "match_id"
    t.string "status", null: false
    t.bigint "created_by_id"
    t.text "notes_ciphertext"
    t.datetime "datetime", null: false
    t.index ["created_by_id"], name: "index_match_status_changes_on_created_by_id"
    t.index ["match_id"], name: "index_match_status_changes_on_match_id"
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "caller_id", null: false
    t.bigint "callee_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "pod_id", null: false
    t.datetime "deleted_at"
    t.string "status"
    t.text "status_change_notes_ciphertext"
    t.datetime "status_change_datetime"
    t.string "report_frequency"
    t.date "alerts_paused_until"
    t.index ["callee_id", "caller_id"], name: "index_matches_on_callee_id_and_caller_id", unique: true
    t.index ["callee_id"], name: "index_matches_on_callee_id"
    t.index ["caller_id"], name: "index_matches_on_caller_id"
    t.index ["pod_id"], name: "index_matches_on_pod_id"
  end

  create_table "notes", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "person_id"
    t.bigint "created_by_id", null: false
    t.datetime "deleted_at"
    t.text "content_ciphertext"
    t.string "note_type"
    t.index ["created_by_id"], name: "index_notes_on_created_by_id"
    t.index ["person_id"], name: "index_notes_on_person_id"
  end

  create_table "people", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "title_ciphertext"
    t.text "first_name_ciphertext", null: false
    t.text "last_name_ciphertext", null: false
    t.text "phone_ciphertext"
    t.text "email_ciphertext"
    t.text "address_line_1_ciphertext"
    t.text "address_line_2_ciphertext"
    t.text "address_town_ciphertext"
    t.text "address_postcode_ciphertext"
    t.string "auth0_id"
    t.boolean "flag_in_progress"
    t.string "age_bracket"
    t.text "flag_change_notes_ciphertext"
    t.datetime "flag_change_datetime"
    t.datetime "invite_email_sent_at"
    t.string "opas_id"
  end

  create_table "person_flag_changes", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "person_id"
    t.boolean "flag_in_progress"
    t.text "notes_ciphertext"
    t.datetime "datetime"
    t.bigint "created_by_id"
    t.index ["created_by_id"], name: "index_person_flag_changes_on_created_by_id"
    t.index ["person_id"], name: "index_person_flag_changes_on_person_id"
  end

  create_table "pod_leaders", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "person_id", null: false
    t.text "status_change_notes_ciphertext"
    t.string "status", null: false
    t.datetime "status_change_datetime"
    t.boolean "report_received_email_updates"
    t.index ["person_id"], name: "index_pod_leaders_on_person_id"
  end

  create_table "pod_supporters", force: :cascade do |t|
    t.bigint "pod_id", null: false
    t.bigint "supporter_id", null: false
    t.index ["pod_id"], name: "index_pod_supporters_on_pod_id"
    t.index ["supporter_id"], name: "index_pod_supporters_on_supporter_id"
  end

  create_table "pods", force: :cascade do |t|
    t.string "name"
    t.bigint "pod_leader_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "theme"
    t.bigint "safeguarding_lead_id"
    t.index ["pod_leader_id"], name: "index_pods_on_pod_leader_id"
    t.index ["safeguarding_lead_id"], name: "index_pods_on_safeguarding_lead_id"
  end

  create_table "referral_status_changes", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "referral_id", null: false
    t.string "status", null: false
    t.text "notes_ciphertext"
    t.datetime "datetime", null: false
    t.bigint "created_by_id", null: false
    t.index ["created_by_id"], name: "index_referral_status_changes_on_created_by_id"
    t.index ["referral_id"], name: "index_referral_status_changes_on_referral_id"
  end

  create_table "referrals", force: :cascade do |t|
    t.datetime "submitted_at", null: false
    t.string "referrer_type"
    t.text "referrer_organisation_ciphertext"
    t.text "referrer_full_name_ciphertext"
    t.text "referrer_phone_ciphertext"
    t.text "referrer_email_ciphertext"
    t.text "first_name_ciphertext", null: false
    t.text "last_name_ciphertext", null: false
    t.text "phone_ciphertext", null: false
    t.string "age_bracket"
    t.text "date_of_birth_ciphertext"
    t.text "address_line_1_ciphertext"
    t.text "address_line_2_ciphertext"
    t.text "address_town_ciphertext"
    t.text "address_postcode_ciphertext"
    t.text "reason_for_referral_ciphertext"
    t.text "additional_needs_ciphertext"
    t.text "other_information_ciphertext"
    t.text "other_support_ciphertext"
    t.text "languages_ciphertext"
    t.text "emergency_contact_name_ciphertext"
    t.text "emergency_contact_relationship_ciphertext"
    t.text "emergency_contact_details_ciphertext"
    t.bigint "callee_id"
    t.string "status", null: false
    t.text "notes_ciphertext"
    t.datetime "status_changed_at", null: false
    t.boolean "confirm_consent", null: false
    t.boolean "confirm_data_shared", null: false
    t.boolean "confirm_data_protection", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["callee_id"], name: "index_referrals_on_callee_id"
  end

  create_table "reports", force: :cascade do |t|
    t.string "duration"
    t.text "summary_ciphertext"
    t.string "callee_feeling"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "match_id"
    t.text "legacy_caller_email_ciphertext"
    t.text "legacy_caller_name_ciphertext"
    t.text "legacy_callee_name_ciphertext"
    t.text "legacy_time_and_date_ciphertext"
    t.string "legacy_time"
    t.string "legacy_date"
    t.string "legacy_duration"
    t.boolean "concerns"
    t.text "concerns_notes_ciphertext"
    t.text "legacy_outcome_ciphertext"
    t.integer "legacy_pod_id"
    t.datetime "archived_at"
    t.string "caller_feeling"
    t.date "date_of_call"
    t.text "no_answer_notes_ciphertext"
    t.index ["match_id"], name: "index_reports_on_match_id"
  end

  create_table "role_status_changes", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "caller_id"
    t.bigint "callee_id"
    t.bigint "admin_id"
    t.bigint "pod_leader_id"
    t.string "status", null: false
    t.text "notes_ciphertext"
    t.datetime "datetime", null: false
    t.bigint "created_by_id"
    t.index ["admin_id"], name: "index_role_status_changes_on_admin_id"
    t.index ["callee_id"], name: "index_role_status_changes_on_callee_id"
    t.index ["caller_id"], name: "index_role_status_changes_on_caller_id"
    t.index ["created_by_id"], name: "index_role_status_changes_on_created_by_id"
    t.index ["pod_leader_id"], name: "index_role_status_changes_on_pod_leader_id"
  end

  create_table "safeguarding_concern_status_changes", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "safeguarding_concern_id", null: false
    t.string "status", null: false
    t.text "notes_ciphertext"
    t.datetime "datetime", null: false
    t.bigint "created_by_id", null: false
    t.index ["created_by_id"], name: "index_safeguarding_concern_status_changes_on_created_by_id"
    t.index ["safeguarding_concern_id"], name: "safeguarding_concerns_on_status_changes"
  end

  create_table "safeguarding_concerns", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "person_id", null: false
    t.bigint "created_by_id", null: false
    t.text "concerns_ciphertext", null: false
    t.string "status", null: false
    t.datetime "status_changed_at", null: false
    t.text "status_changed_notes_ciphertext"
    t.index ["created_by_id"], name: "index_safeguarding_concerns_on_created_by_id"
    t.index ["person_id"], name: "index_safeguarding_concerns_on_person_id"
  end

  add_foreign_key "admins", "people"
  add_foreign_key "callees", "people"
  add_foreign_key "callees", "pods"
  add_foreign_key "callers", "people"
  add_foreign_key "callers", "pods"
  add_foreign_key "emergency_contacts", "callees"
  add_foreign_key "events", "events", column: "replacement_event_id"
  add_foreign_key "events", "matches"
  add_foreign_key "events", "notes"
  add_foreign_key "events", "people"
  add_foreign_key "events", "people", column: "created_by_id"
  add_foreign_key "events", "reports"
  add_foreign_key "match_status_changes", "matches"
  add_foreign_key "match_status_changes", "people", column: "created_by_id"
  add_foreign_key "matches", "callees"
  add_foreign_key "matches", "callers"
  add_foreign_key "matches", "pods"
  add_foreign_key "notes", "people"
  add_foreign_key "notes", "people", column: "created_by_id"
  add_foreign_key "person_flag_changes", "people"
  add_foreign_key "person_flag_changes", "people", column: "created_by_id"
  add_foreign_key "pod_leaders", "people"
  add_foreign_key "pod_supporters", "pod_leaders", column: "supporter_id"
  add_foreign_key "pod_supporters", "pods"
  add_foreign_key "pods", "people", column: "safeguarding_lead_id"
  add_foreign_key "pods", "pod_leaders"
  add_foreign_key "referral_status_changes", "people", column: "created_by_id"
  add_foreign_key "referral_status_changes", "referrals"
  add_foreign_key "referrals", "callees"
  add_foreign_key "reports", "matches"
  add_foreign_key "role_status_changes", "admins"
  add_foreign_key "role_status_changes", "callees"
  add_foreign_key "role_status_changes", "callers"
  add_foreign_key "role_status_changes", "people", column: "created_by_id"
  add_foreign_key "role_status_changes", "pod_leaders"
  add_foreign_key "safeguarding_concern_status_changes", "people", column: "created_by_id"
  add_foreign_key "safeguarding_concern_status_changes", "safeguarding_concerns"
  add_foreign_key "safeguarding_concerns", "people"
  add_foreign_key "safeguarding_concerns", "people", column: "created_by_id"
end
