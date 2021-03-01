class EventsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.timestamps

      t.string :type
      t.string :version
      t.datetime :occurred_at

      t.text :sensitive_data_ciphertext
      t.column :non_sensitive_data, :jsonb, null: false, default: {}

      t.references :person, null: false, foreign_key: true
      t.references :replacement_event, foreign_key: { to_table: :events }
      t.references :created_by, foreign_key: { to_table: :people }

      t.references :match, foreign_key: true
      t.references :report, foreign_key: true
      t.references :note, foreign_key: true
    end
  end
end
