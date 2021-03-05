class RoleStatus < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :status_change_notes_ciphertext, :text
    add_column :matches, :status_change_datetime, :datetime

    add_column :match_status_changes, :notes_ciphertext, :text
    add_column :match_status_changes, :datetime, :datetime
    change_column_null :match_status_changes, :created_at, true

    add_column :callers, :status_change_notes_ciphertext, :text
    add_column :callees, :status_change_notes_ciphertext, :text
    add_column :admins, :status_change_notes_ciphertext, :text
    add_column :pod_leaders, :status_change_notes_ciphertext, :text
    add_column :callers, :status, :string
    add_column :callees, :status, :string
    add_column :admins, :status, :string
    add_column :pod_leaders, :status, :string
    add_column :callers, :status_change_datetime, :datetime
    add_column :callees, :status_change_datetime, :datetime
    add_column :admins, :status_change_datetime, :datetime
    add_column :pod_leaders, :status_change_datetime, :datetime

    create_table :role_status_changes do |t|
      t.timestamps

      t.references :caller, foreign_key: true
      t.references :callee, foreign_key: true
      t.references :admin, foreign_key: true
      t.references :pod_leader, foreign_key: true

      t.string :status
      t.text :notes_ciphertext
      t.datetime :datetime
      t.references :created_by, null: true, foreign_key: { to_table: :people }
    end

    add_column :people, :flag_change_notes_ciphertext, :text
    add_column :people, :flag_change_datetime, :datetime

    remove_column :people, :flag_updated_at, :date
    remove_column :people, :flag_updated_by_id, :integer
    remove_column :people, :flag_note_ciphertext, :text

    create_table :person_flag_changes do |t|
      t.timestamps

      t.references :person, foreign_key: true

      t.boolean :flag_in_progress
      t.text :notes_ciphertext
      t.datetime :datetime
      t.references :created_by, null: true, foreign_key: { to_table: :people }
    end
  end
end
