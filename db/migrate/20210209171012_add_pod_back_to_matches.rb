class AddPodBackToMatches < ActiveRecord::Migration[6.0]
  def change
    add_reference :matches, :pod, null: false, foreign_key: true, index: true

    add_column :matches, :end_reason, :string
    add_column :matches, :end_reason_notes_ciphertext, :text
  end
end
