class EmergencyContactTable < ActiveRecord::Migration[6.0]
  def change
    add_column :callees, :call_frequency_ciphertext, :text

    add_column :people, :age_bracket, :string

    create_table :emergency_contacts do |t|
      t.timestamps

      t.references :callee, null: false, foreign_key: true, index: true

      t.text :name_ciphertext, null: false
      t.text :contact_details_ciphertext, null: false
      t.text :relationship_ciphertext, null: false
    end

    add_column :callees, :added_to_waiting_list, :date
    add_column :callers, :added_to_waiting_list, :date

    change_column :matches, :start_date, :date, null: true
  end
end
