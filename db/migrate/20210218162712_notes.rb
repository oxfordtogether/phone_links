class Notes < ActiveRecord::Migration[6.0]
  def change
    add_column :callees, :flag_in_progress, :boolean
    add_column :callees, :flag_updated_at, :datetime
    add_column :callees, :flag_updated_by_id, :integer
    add_column :callees, :flag_note_ciphertext, :text
  end
end
