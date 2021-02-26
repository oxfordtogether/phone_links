class MoreReportFields < ActiveRecord::Migration[6.0]
  def change
    add_column :reports, :legacy_caller_email_ciphertext, :text
    add_column :reports, :legacy_caller_name_ciphertext, :text
    add_column :reports, :legacy_callee_name_ciphertext, :text

    add_column :reports, :legacy_time_and_date_ciphertext, :text
    add_column :reports, :legacy_time, :string
    add_column :reports, :legacy_date, :string

    add_column :reports, :legacy_duration, :string

    add_column :reports, :concerns, :boolean
    add_column :reports, :concerns_notes_ciphertext, :text

    add_column :reports, :legacy_outcome_ciphertext, :text

    add_column :reports, :archived_at, :datetime
  end
end
