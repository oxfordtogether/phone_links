class CallerInteractions < ActiveRecord::Migration[6.0]
  def change
    add_column :notes, :note_type, :string

    add_column :callers, :next_check_in, :date
    add_column :callers, :pod_whatsapp_membership, :boolean

    add_column :callers, :has_capacity, :boolean
    add_column :callers, :capacity_notes_ciphertext, :text
    add_column :callers, :capacity_last_updated, :datetime

		add_column :callees, :summary_ciphertext, :text
  end
end
