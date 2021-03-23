class Languages < ActiveRecord::Migration[6.0]
  def change
    add_column :callers, :languages_notes_ciphertext, :text
    add_column :callees, :languages_notes_ciphertext, :text
  end
end
