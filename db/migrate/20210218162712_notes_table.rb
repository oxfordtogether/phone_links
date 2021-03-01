class NotesTable < ActiveRecord::Migration[6.0]
  def change
    add_column :people, :flag_in_progress, :boolean
    add_column :people, :flag_updated_at, :datetime
    add_column :people, :flag_updated_by_id, :integer
    add_column :people, :flag_note_ciphertext, :text

    create_table :notes do |t|
      t.timestamps

      t.references :person, null: true, foreign_key: true
      t.references :created_by, null: false, foreign_key: { to_table: :people }

      t.datetime :deleted_at
      t.text :content_ciphertext
    end
  end
end
