class AddNotesToReport < ActiveRecord::Migration[6.0]
  def change
    add_column :reports, :no_answer_notes_ciphertext, :text
  end
end
