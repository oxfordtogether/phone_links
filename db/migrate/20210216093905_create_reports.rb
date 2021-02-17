class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.string :duration
      t.text :summary_ciphertext
      t.datetime :datetime
      t.string :callee_state
      t.timestamps
      t.references :match, null: true, foreign_key: true
    end
  end
end
