class Notes < ActiveRecord::Migration[6.0]
  def change
    add_column :callees, :flag_in_progress, :boolean
    add_column :callees, :flag_updated_at, :datetime
    add_column :callees, :flag_updated_by_id, :integer
    add_column :callees, :flag_note_ciphertext, :text

    create_table :notes do |t|
      t.timestamps

      t.references :callee, null: true, foreign_key: true
      t.references :created_by, null: false, foreign_key: { to_table: :people }

      t.text :content_ciphertext
    end
  end
end
