class SafeguardingTables < ActiveRecord::Migration[6.0]
  def change
    create_table :safeguarding_concerns do |t|
      t.timestamps

      t.references :person, null: false, foreign_key: true
      t.references :created_by, null: false, foreign_key: { to_table: :people }

      t.text :concerns_ciphertext, null: false

      t.string :status, null: false
      t.datetime :status_changed_at, null: false
      t.text :status_changed_notes_ciphertext, null: true
    end

    add_reference :pods, :safeguarding_lead, null: true, foreign_key: { to_table: :people }

    create_table :safeguarding_concern_status_changes do |t|
      t.timestamps

      t.references :safeguarding_concern, null: false, foreign_key: true, index: { name: :safeguarding_concerns_on_status_changes }

      t.string :status, null: false
      t.text :notes_ciphertext, null: true
      t.datetime :datetime, null: false
      t.references :created_by, null: false, foreign_key: { to_table: :people }
    end
  end
end
