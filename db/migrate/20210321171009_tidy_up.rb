class TidyUp < ActiveRecord::Migration[6.0]
  def change
    remove_column :matches, :start_date, :date
    remove_column :matches, :end_date, :date
    remove_column :matches, :end_reason, :string
    remove_column :matches, :end_reason_notes_ciphertext, :text

    remove_column :admins, :active, :boolean
    remove_column :callers, :active, :boolean
    remove_column :pod_leaders, :active, :boolean
    remove_column :callees, :active, :boolean

    change_column_null :admins, :status, false
    change_column_null :pod_leaders, :status, false
    change_column_null :callees, :status, false
    change_column_null :callers, :status, false

    change_column_null :match_status_changes, :status, false
    change_column_null :match_status_changes, :datetime, false

    change_column_null :role_status_changes, :status, false
    change_column_null :role_status_changes, :datetime, false
  end
end
