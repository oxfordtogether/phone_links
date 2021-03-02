class EmergencyContact < ActiveRecord::Migration[6.0]
  def change
    add_column :callees, :call_frequency_ciphertext, :text

    add_column :people, :age_bracket, :string
  end
end
